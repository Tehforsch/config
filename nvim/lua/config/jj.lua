local M = {}

local blame_namespace = vim.api.nvim_create_namespace("jj_current_line_blame")
local blame_cache = {}
local blame_group = vim.api.nvim_create_augroup("JJCurrentLineBlame", { clear = true })
local squash_in_progress = {}

local function notify_error(context, result)
	local detail = vim.trim(result.stderr or "")
	if detail == "" then detail = vim.trim(result.stdout or "") end
	if detail == "" then detail = "command exited with status " .. result.code end
	vim.notify(context .. ": " .. detail, vim.log.levels.ERROR)
end

local function run(args, opts, callback)
	opts = opts or {}
	vim.system(args, { cwd = opts.cwd, env = opts.env, text = true }, function(result)
		vim.schedule(function() callback(result) end)
	end)
end

local function buffer_directory()
	local name = vim.api.nvim_buf_get_name(0)
	if name ~= "" and not name:match("^%w+://") then return vim.fs.dirname(vim.fs.normalize(name)) end
	return vim.fn.getcwd(0)
end

local function with_root(callback)
	run({ "jj", "--color=never", "root" }, { cwd = buffer_directory() }, function(result)
		if result.code ~= 0 then
			notify_error("Not in a JJ repository", result)
			return
		end
		callback(vim.trim(result.stdout))
	end)
end

function M.pick_hunks()
	with_root(function(root)
		run({ "jj", "--color=never", "diff", "--git" }, { cwd = root }, function(result)
			if result.code ~= 0 then
				notify_error("Could not read the JJ diff", result)
				return
			end
			if result.stdout == "" then
				vim.notify("No working-copy changes", vim.log.levels.INFO)
				return
			end

			Snacks.picker.pick({
				title = "Working-copy hunks",
				cwd = root,
				finder = function(opts, ctx) return require("snacks.picker.source.diff").diff(vim.tbl_extend("force", opts, { diff = result.stdout, cwd = root }), ctx) end,
				format = "file",
				preview = "diff",
			})
		end)
	end)
end

local revision_template = table.concat({
	"commit_id",
	'"\\t"',
	"change_id.shortest(8)",
	'"\\t"',
	'if(current_working_copy, "@")',
	'"\\t"',
	'bookmarks.join(", ")',
	'"\\t"',
	"description.first_line()",
	'"\\n"',
}, " ++ ")

local function parse_revisions(output, root)
	local current_commit
	local items = {}

	for _, line in ipairs(vim.split(output, "\n", { plain = true, trimempty = true })) do
		local fields = vim.split(line, "\t", { plain = true })
		local commit = fields[1]
		local change = fields[2]
		local marker = fields[3]
		local bookmarks = fields[4]
		local description = table.concat(fields, "\t", 5)

		if marker == "@" then
			current_commit = commit
		elseif commit and commit ~= "" then
			local label = bookmarks ~= "" and (bookmarks .. "  ") or ""
			if description == "" then description = "(no description)" end
			table.insert(items, {
				text = string.format("%s  %s  %s%s", change, commit:sub(1, 12), label, description),
				commit = commit,
				cwd = root,
			})
		end
	end

	return items, current_commit
end

function M.pick_diff_source()
	with_root(function(root)
		run({
			"jj",
			"--color=never",
			"log",
			"--no-graph",
			"-r",
			"all()",
			"-n",
			"500",
			"-T",
			revision_template,
		}, { cwd = root }, function(result)
			if result.code ~= 0 then
				notify_error("Could not list JJ revisions", result)
				return
			end

			local items, current_commit = parse_revisions(result.stdout, root)
			if not current_commit then
				vim.notify("Could not resolve the JJ working-copy revision", vim.log.levels.ERROR)
				return
			end

			Snacks.picker.pick({
				title = "Diff source → @",
				cwd = root,
				items = items,
				format = "text",
				preview = function() end,
				layout = { preview = false },
				confirm = function(picker, item)
					if not item then return end
					picker:close()
					vim.api.nvim_cmd({ cmd = "CodeDiff", args = { "-C", root, item.commit, current_commit } }, {})
				end,
			})
		end)
	end)
end

local function build_hunk_patch(file_path, original_lines, modified_lines, original_start, modified_start)
	local original_count = #original_lines
	local modified_count = #modified_lines
	local header_original_start = original_count == 0 and math.max(0, original_start - 1) or original_start
	local header_modified_start = modified_count == 0 and math.max(0, modified_start - 1) or modified_start

	local parts = {
		"--- a/" .. file_path,
		"+++ b/" .. file_path,
		string.format("@@ -%d,%d +%d,%d @@", header_original_start, original_count, header_modified_start, modified_count),
	}
	for _, line in ipairs(original_lines) do
		table.insert(parts, "-" .. line)
	end
	for _, line in ipairs(modified_lines) do
		table.insert(parts, "+" .. line)
	end
	return table.concat(parts, "\n") .. "\n"
end

local function write_temp_patch(patch)
	local path = vim.fn.tempname() .. ".patch"
	local fd, open_error = vim.uv.fs_open(path, "w", 384)
	if not fd then return nil, open_error end
	local written, write_error = vim.uv.fs_write(fd, patch, 0)
	vim.uv.fs_close(fd)
	if not written then
		vim.fn.delete(path)
		return nil, write_error
	end
	return path
end

local function squash_tool_path()
	local config_dir = vim.uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
	return vim.fs.joinpath(vim.fs.dirname(config_dir), "scripts", "jj-codediff-hunk.sh")
end

local function refresh_parent_diff(tabpage, root)
	run({
		"jj",
		"--ignore-working-copy",
		"--color=never",
		"log",
		"--no-graph",
		"-r",
		"@ | @-",
		"-T",
		'if(current_working_copy, "current", "parent") ++ "\\t" ++ commit_id ++ "\\n"',
	}, { cwd = root }, function(result)
		if result.code ~= 0 then
			notify_error("Squashed the hunk, but could not resolve the rewritten revisions", result)
			return
		end

		local revisions = {}
		for _, line in ipairs(vim.split(result.stdout, "\n", { plain = true, trimempty = true })) do
			local kind, commit = line:match("^(%S+)\t(%x+)$")
			if kind and commit then revisions[kind] = commit end
		end
		if not revisions.parent or not revisions.current then
			vim.notify("Squashed the hunk, but could not refresh CodeDiff", vim.log.levels.WARN)
			return
		end

		local session = require("codediff.ui.lifecycle").get_session(tabpage)
		local explorer = session and session.explorer or nil
		if not explorer or not require("codediff.ui.explorer").retarget_revisions(explorer, revisions.parent, revisions.current) then
			vim.notify("Squashed the hunk, but could not retarget CodeDiff", vim.log.levels.WARN)
		end
	end)
end

local function squash_vcsigns_hunk()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].buftype ~= "" or vim.api.nvim_buf_get_name(bufnr) == "" then
		vim.notify("Squashing a hunk requires a file-backed buffer", vim.log.levels.WARN)
		return
	end
	if vim.bo[bufnr].modified then
		vim.notify("Save the buffer before squashing a JJ hunk", vim.log.levels.WARN)
		return
	end

	local state_ok, state = pcall(require, "vcsigns.state")
	if not state_ok then
		vim.notify("VCSigns has not attached to this buffer", vim.log.levels.WARN)
		return
	end
	local buffer_state = state.get(bufnr)
	local vcs = buffer_state.vcs.vcs
	if not vcs or vcs.name ~= "Jujutsu" then
		vim.notify("Squashing a normal-buffer hunk requires VCSigns with its JJ backend", vim.log.levels.WARN)
		return
	end

	local repo_state = state.repo_get(vcs.root)
	if repo_state.offset ~= 0 or repo_state.revset then
		vim.notify("Set the VCSigns diff target back to @ before squashing a hunk", vim.log.levels.WARN)
		return
	end
	if vim.b[bufnr].vcsigns_resolved_rename then
		vim.notify("Squashing a renamed file is not supported yet", vim.log.levels.WARN)
		return
	end

	local hunk = require("vcsigns.hunkops").cur_hunk(vim.fn.line("."), buffer_state.diff.hunks)
	if not hunk then
		vim.notify("Move the cursor onto a VCSigns hunk first", vim.log.levels.WARN)
		return
	end
	local hunk_index
	for index, candidate in ipairs(buffer_state.diff.hunks) do
		if candidate == hunk then
			hunk_index = index
			break
		end
	end

	local root = vcs.root
	local file_path = vim.fs.relpath(root, vim.api.nvim_buf_get_name(bufnr))
	if not file_path then
		vim.notify("The current file is outside the JJ repository", vim.log.levels.ERROR)
		return
	end
	local parent_result = vim
		.system({
			"jj",
			"--ignore-working-copy",
			"--color=never",
			"log",
			"--no-graph",
			"-r",
			"@-",
			"-T",
			"commit_id",
		}, { cwd = root, text = true })
		:wait()
	if parent_result.code ~= 0 then
		notify_error("Could not resolve the JJ parent revision", parent_result)
		return
	end
	local parent_commit = vim.trim(parent_result.stdout)
	if vim.system({ "git", "cat-file", "-e", parent_commit .. ":" .. file_path }, { cwd = root }):wait().code ~= 0 then
		vim.notify("Squashing an added file is not supported yet", vim.log.levels.WARN)
		return
	end

	local patch = build_hunk_patch(file_path, hunk.minus_lines, hunk.plus_lines, hunk.minus_start, hunk.plus_start)
	local patch_path, patch_error = write_temp_patch(patch)
	if not patch_path then
		vim.notify("Could not write the selected hunk: " .. tostring(patch_error), vim.log.levels.ERROR)
		return
	end

	local progress_key = "buffer:" .. bufnr
	if squash_in_progress[progress_key] then
		vim.fn.delete(patch_path)
		vim.notify("A hunk squash is already running", vim.log.levels.INFO)
		return
	end
	squash_in_progress[progress_key] = true
	run({ "jj", "--color=never", "log", "--no-graph", "-r", "@", "-T", "commit_id" }, { cwd = root }, function(current_result)
		if current_result.code ~= 0 then
			squash_in_progress[progress_key] = nil
			vim.fn.delete(patch_path)
			notify_error("Could not snapshot the JJ working-copy revision", current_result)
			return
		end

		local tool_config = "ui.diff-editor=" .. vim.json.encode({ "sh", squash_tool_path(), "$left", "$right", "$output" })
		run({
			"jj",
			"--color=never",
			"--config",
			tool_config,
			"squash",
			"--interactive",
			"--from",
			"@",
			"--into",
			"@-",
			"--keep-emptied",
		}, { cwd = root, env = { JJ_CODEDIFF_PATCH = patch_path } }, function(result)
			squash_in_progress[progress_key] = nil
			vim.fn.delete(patch_path)
			if result.code ~= 0 then
				local detail = (result.stderr or "") .. (result.stdout or "")
				if detail:find("patch does not apply", 1, true) then
					vim.notify("This hunk is no longer part of @, so JJ left the revisions unchanged", vim.log.levels.WARN)
				else
					notify_error("Could not squash the hunk into @-", result)
				end
				return
			end

			vim.notify(string.format("Squashed VCSigns hunk %d into @-", hunk_index or 0), vim.log.levels.INFO)
			if vim.api.nvim_buf_is_valid(bufnr) then require("vcsigns.actions").start(bufnr) end
		end)
	end)
end

function M.squash_current_hunk()
	local lifecycle_ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
	local tabpage = vim.api.nvim_get_current_tabpage()
	local session = lifecycle_ok and lifecycle.get_session(tabpage) or nil
	if not session then return squash_vcsigns_hunk() end
	if not session or not session.git_root or not session.original_revision or not session.modified_revision then
		vim.notify("Squashing a hunk requires a revision-to-revision CodeDiff view", vim.log.levels.WARN)
		return
	end
	if squash_in_progress[tabpage] then
		vim.notify("A hunk squash is already running", vim.log.levels.INFO)
		return
	end

	local original_bufnr, modified_bufnr = lifecycle.get_buffers(tabpage)
	if not original_bufnr or not modified_bufnr then
		vim.notify("CodeDiff has no file selected", vim.log.levels.WARN)
		return
	end

	local context = {
		tabpage = tabpage,
		original_bufnr = original_bufnr,
		modified_bufnr = modified_bufnr,
		is_inline = session.layout == "inline",
	}
	local hunk, hunk_index = require("codediff.ui.view.actions.hunk").find_hunk_at_cursor(context)
	if not hunk then
		vim.notify("Move the cursor onto a CodeDiff hunk first", vim.log.levels.WARN)
		return
	end

	local original_path = session.original and session.original.relative or ""
	local modified_path = session.modified and session.modified.relative or ""
	if original_path == "" or modified_path == "" or original_path ~= modified_path then
		vim.notify("Squashing added, deleted, or renamed files is not supported yet", vim.log.levels.WARN)
		return
	end

	local root = session.git_root
	local original_exists = vim.system({ "git", "cat-file", "-e", session.original_revision .. ":" .. original_path }, { cwd = root }):wait().code == 0
	local modified_exists = vim.system({ "git", "cat-file", "-e", session.modified_revision .. ":" .. modified_path }, { cwd = root }):wait().code == 0
	if not original_exists or not modified_exists then
		vim.notify("Squashing added or deleted files is not supported yet", vim.log.levels.WARN)
		return
	end

	local original_lines = vim.api.nvim_buf_get_lines(original_bufnr, hunk.original.start_line - 1, hunk.original.end_line - 1, false)
	local modified_lines = vim.api.nvim_buf_get_lines(modified_bufnr, hunk.modified.start_line - 1, hunk.modified.end_line - 1, false)
	local patch = build_hunk_patch(original_path, original_lines, modified_lines, hunk.original.start_line, hunk.modified.start_line)
	local patch_path, patch_error = write_temp_patch(patch)
	if not patch_path then
		vim.notify("Could not write the selected hunk: " .. tostring(patch_error), vim.log.levels.ERROR)
		return
	end

	squash_in_progress[tabpage] = true
	run({ "jj", "--color=never", "log", "--no-graph", "-r", "@", "-T", "commit_id" }, { cwd = root }, function(current_result)
		if current_result.code ~= 0 then
			squash_in_progress[tabpage] = nil
			vim.fn.delete(patch_path)
			notify_error("Could not resolve the JJ working-copy revision", current_result)
			return
		end
		if vim.trim(current_result.stdout) ~= session.modified_revision then
			squash_in_progress[tabpage] = nil
			vim.fn.delete(patch_path)
			vim.notify("JJ @ changed after CodeDiff opened; reopen the diff before squashing", vim.log.levels.WARN)
			return
		end

		local tool = squash_tool_path()
		local tool_config = "ui.diff-editor=" .. vim.json.encode({ "sh", tool, "$left", "$right", "$output" })
		run({
			"jj",
			"--color=never",
			"--config",
			tool_config,
			"squash",
			"--interactive",
			"--from",
			"@",
			"--into",
			"@-",
			"--keep-emptied",
		}, { cwd = root, env = { JJ_CODEDIFF_PATCH = patch_path } }, function(result)
			squash_in_progress[tabpage] = nil
			vim.fn.delete(patch_path)
			if result.code ~= 0 then
				local detail = (result.stderr or "") .. (result.stdout or "")
				if detail:find("patch does not apply", 1, true) then
					vim.notify("This displayed hunk was not introduced by @, so JJ left the revisions unchanged", vim.log.levels.WARN)
				else
					notify_error("Could not squash the hunk into @-", result)
				end
				return
			end

			vim.notify(string.format("Squashed CodeDiff hunk %d into @-", hunk_index), vim.log.levels.INFO)
			refresh_parent_diff(tabpage, root)
		end)
	end)
end

function M.add_review_note(visual)
	local lifecycle = require("codediff.ui.lifecycle")
	local tabpage = vim.api.nvim_get_current_tabpage()
	local session = lifecycle.get_session(tabpage)
	if not session then return end

	local bufnr = vim.api.nvim_get_current_buf()
	local original_bufnr, modified_bufnr = lifecycle.get_buffers(tabpage)
	local file
	local side
	if bufnr == original_bufnr then
		file = session.original
		side = "LEFT"
	elseif bufnr == modified_bufnr then
		file = session.modified
		side = "RIGHT"
	else
		vim.notify("Move the cursor into a CodeDiff pane before adding a review note", vim.log.levels.WARN)
		return
	end
	if not file or file.relative == "" then
		vim.notify("The current CodeDiff pane has no file", vim.log.levels.WARN)
		return
	end

	local start_line
	local start_column
	local end_line
	local end_column
	if visual then
		local anchor = vim.fn.getpos("v")
		local cursor = vim.fn.getpos(".")
		if anchor[2] < cursor[2] or (anchor[2] == cursor[2] and anchor[3] <= cursor[3]) then
			start_line, start_column = anchor[2], anchor[3]
			end_line, end_column = cursor[2], cursor[3]
		else
			start_line, start_column = cursor[2], cursor[3]
			end_line, end_column = anchor[2], anchor[3]
		end
	else
		local cursor = vim.api.nvim_win_get_cursor(0)
		start_line = cursor[1]
		start_column = cursor[2] + 1
		end_line = start_line
		end_column = start_column
	end
	local metadata = {
		path = file.relative,
		line = end_line,
		column = end_column,
		side = side,
		original_revision = session.original_revision,
		modified_revision = session.modified_revision,
	}
	if start_line ~= end_line then
		metadata.start_line = start_line
		metadata.start_column = start_column
		metadata.start_side = side
	end
	local location = start_line == end_line and tostring(start_line) or string.format("%d-%d", start_line, end_line)
	vim.ui.input({ prompt = string.format("Review note for %s:%s: ", metadata.path, location) }, function(comment)
		if not comment or vim.trim(comment) == "" then return end
		metadata.body = vim.trim(comment)

		local result = vim.system({ "git", "rev-parse", "--git-path", "codediff-review-notes.md" }, { cwd = session.git_root, text = true }):wait()
		if result.code ~= 0 then
			notify_error("Could not find storage for review notes", result)
			return
		end
		local notes_path = vim.trim(result.stdout)
		if not vim.startswith(notes_path, "/") then notes_path = vim.fs.joinpath(session.git_root, notes_path) end
		vim.fn.mkdir(vim.fs.dirname(notes_path), "p")
		local lines = {}
		if vim.fn.filereadable(notes_path) == 0 then vim.list_extend(lines, { "# CodeDiff review notes", "" }) end
		local heading_location = start_line == end_line and string.format("%d:%d", end_line, end_column)
			or string.format("%d:%d-%d:%d", start_line, start_column, end_line, end_column)
		vim.list_extend(lines, {
			string.format("## `%s:%s` (%s)", metadata.path, heading_location, metadata.side),
			"",
			vim.trim(comment),
			"",
			"<!-- codediff-review-note " .. vim.json.encode(metadata) .. " -->",
			"",
		})
		local ok, error = pcall(vim.fn.writefile, lines, notes_path, "a")
		if not ok then
			vim.notify("Could not save review note: " .. tostring(error), vim.log.levels.ERROR)
			return
		end
		vim.notify("Saved review note to " .. notes_path, vim.log.levels.INFO)
	end)
end

local function disable_blame(bufnr)
	blame_cache[bufnr] = nil
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.b[bufnr].jj_current_line_blame = false
		vim.api.nvim_buf_clear_namespace(bufnr, blame_namespace, 0, -1)
		vim.api.nvim_clear_autocmds({ group = blame_group, buffer = bufnr })
	end
end

local function render_blame(bufnr)
	local annotations = blame_cache[bufnr]
	if not annotations or vim.api.nvim_get_current_buf() ~= bufnr then return end

	local line = vim.api.nvim_win_get_cursor(0)[1]
	local annotation = annotations[line]
	vim.api.nvim_buf_clear_namespace(bufnr, blame_namespace, 0, -1)
	if not annotation or annotation == "" then return end

	vim.api.nvim_buf_set_extmark(bufnr, blame_namespace, line - 1, 0, {
		virt_text = { { "  " .. annotation, "Comment" } },
		virt_text_pos = "eol",
		priority = 100,
	})
end

function M.toggle_blame()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.b[bufnr].jj_current_line_blame then
		disable_blame(bufnr)
		return
	end
	if vim.bo[bufnr].modified then
		vim.notify("Save the buffer before showing JJ blame", vim.log.levels.WARN)
		return
	end

	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" or filename:match("^%w+://") then
		vim.notify("JJ blame needs a file-backed buffer", vim.log.levels.WARN)
		return
	end

	vim.b[bufnr].jj_current_line_blame = true
	with_root(function(root)
		local relative = vim.fs.relpath(root, filename)
		if not relative then
			disable_blame(bufnr)
			vim.notify("The current file is outside the JJ repository", vim.log.levels.ERROR)
			return
		end

		local template = table.concat({
			"commit.change_id().shortest(8)",
			'"  "',
			"commit.author().name()",
			'"  "',
			"commit.author().timestamp().ago()",
			'"  "',
			"commit.description().first_line()",
			'"\\n"',
		}, " ++ ")

		run({
			"jj",
			"--color=never",
			"file",
			"annotate",
			"-r",
			"@",
			"-T",
			template,
			"--",
			relative,
		}, { cwd = root }, function(result)
			if result.code ~= 0 then
				disable_blame(bufnr)
				notify_error("Could not read JJ blame", result)
				return
			end
			if not vim.api.nvim_buf_is_valid(bufnr) or not vim.b[bufnr].jj_current_line_blame then return end

			blame_cache[bufnr] = vim.split(result.stdout, "\n", { plain = true })
			vim.api.nvim_create_autocmd("CursorMoved", {
				group = blame_group,
				buffer = bufnr,
				callback = function() render_blame(bufnr) end,
			})
			vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWipeout" }, {
				group = blame_group,
				buffer = bufnr,
				once = true,
				callback = function() disable_blame(bufnr) end,
			})
			render_blame(bufnr)
		end)
	end)
end

return M
