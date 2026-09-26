local M = {}

local function notify_error(message) vim.notify("[bookmark-jump.nvim] " .. message, vim.log.levels.ERROR) end

local function normalize(path) return vim.uv.fs_realpath(path) or vim.fs.normalize(path) end

local function git_root(path)
	local directory = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
	if not directory or vim.fn.isdirectory(directory) == 0 then return end

	local result = vim.system({ "git", "-C", directory, "rev-parse", "--show-toplevel" }, { text = true }):wait()
	if result.code ~= 0 then return end

	local root = vim.trim(result.stdout)
	return root ~= "" and normalize(root) or nil
end

local function storage_path(root)
	local directory = vim.fs.joinpath(vim.fn.stdpath("state"), "bookmark-jump")
	local name = vim.fs.basename(root):gsub("[^%w._-]", "_")
	return directory, vim.fs.joinpath(directory, string.format("%s-%s.json", name, vim.fn.sha256(root):sub(1, 12)))
end

local function load_bookmarks(root)
	local _, path = storage_path(root)
	if vim.fn.filereadable(path) == 0 then return {} end

	local read, lines = pcall(vim.fn.readfile, path, "b")
	if not read then
		notify_error("Could not read " .. path)
		return
	end

	local decoded, data = pcall(vim.json.decode, table.concat(lines, "\n"))
	if not decoded or type(data) ~= "table" or type(data.bookmarks) ~= "table" then
		notify_error("Could not decode " .. path)
		return
	end
	if data.root ~= root then
		notify_error("Storage root does not match " .. root)
		return
	end

	return data.bookmarks
end

local function save_bookmarks(root, bookmarks)
	local directory, path = storage_path(root)
	vim.fn.mkdir(directory, "p")

	local encoded, data = pcall(vim.json.encode, {
		version = 1,
		root = root,
		bookmarks = bookmarks,
	})
	if not encoded then
		notify_error("Could not encode bookmarks")
		return false
	end

	local temporary = string.format("%s.%d.tmp", path, vim.fn.getpid())
	if vim.fn.writefile({ data }, temporary, "b") ~= 0 then
		notify_error("Could not write " .. temporary)
		return false
	end

	local renamed, err = vim.uv.fs_rename(temporary, path)
	if not renamed then
		vim.uv.fs_unlink(temporary)
		notify_error("Could not replace " .. path .. ": " .. err)
		return false
	end
	return true
end

local function source_line(file, line)
	local bufnr = vim.fn.bufnr(file)
	local text
	if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
		text = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
	else
		local ok, lines = pcall(vim.fn.readfile, file, "", line)
		text = ok and lines[line] or nil
	end

	text = text and vim.trim(text):gsub("%s+", " ") or ""
	return text ~= "" and text or nil
end

local function function_context()
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if not ok then return end

	local tree = parser:parse()[1]
	if not tree then return end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local node = tree:root():named_descendant_for_range(cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2])
	while node do
		local node_type = node:type()
		local is_function = node_type:find("function", 1, true) and not node_type:find("call", 1, true)
		local is_method = node_type:find("method_definition", 1, true) or node_type:find("method_declaration", 1, true)
		if is_function or is_method then
			local name = node:field("name")[1]
			if name then
				local text = vim.treesitter.get_node_text(name, 0)
				return "function " .. vim.trim(text):gsub("%s+", " ")
			end

			local row = node:range()
			return source_line(vim.api.nvim_buf_get_name(0), row + 1)
		end
		node = node:parent()
	end
end

local function current_location(allow_cwd)
	local file = vim.api.nvim_buf_get_name(0)
	local root
	if file ~= "" then root = git_root(file) end
	if not root and allow_cwd then root = git_root(vim.fn.getcwd()) end
	if not root then
		notify_error("The current file is not in a Git repository")
		return
	end
	if file == "" then return root end

	local cursor = vim.api.nvim_win_get_cursor(0)
	return root,
		{
			path = vim.fs.relpath(root, normalize(file)),
			line = cursor[1],
			col = cursor[2] + 1,
			context = function_context() or source_line(file, cursor[1]),
		}
end

local function display_text(bookmark)
	local location = string.format("%s:%d:%d", bookmark.path, bookmark.line, bookmark.col)
	local text = bookmark.label and bookmark.label ~= "" and (bookmark.label .. "  ·  " .. location) or location
	if bookmark.context then text = text .. "  " .. bookmark.context end
	return text
end

local function picker_items(root, bookmarks)
	local items = {}
	for index, bookmark in ipairs(bookmarks) do
		items[#items + 1] = vim.tbl_extend("force", bookmark, {
			bookmark_index = index,
			file = vim.fs.joinpath(root, bookmark.path),
			text = display_text(bookmark),
			pos = { bookmark.line, bookmark.col },
		})
	end
	return items
end

local function open_bookmark(item, command)
	if not item or vim.fn.filereadable(item.file) ~= 1 then
		notify_error("Bookmark file no longer exists")
		return
	end

	vim.cmd((command or "edit") .. " " .. vim.fn.fnameescape(item.file))
	local line = math.min(item.line, vim.api.nvim_buf_line_count(0))
	vim.api.nvim_win_set_cursor(0, { line, math.max(item.col - 1, 0) })
end

function M.add()
	local root, bookmark = current_location(false)
	if not root then return end

	vim.ui.input({ prompt = "Bookmark label: " }, function(label)
		if label == nil then return end
		label = vim.trim(label)
		bookmark.label = label ~= "" and label or nil

		local bookmarks = load_bookmarks(root)
		if not bookmarks then return end

		local updated = false
		for index, existing in ipairs(bookmarks) do
			if existing.path == bookmark.path and existing.line == bookmark.line and existing.col == bookmark.col then
				bookmarks[index] = bookmark
				updated = true
				break
			end
		end
		if not updated then bookmarks[#bookmarks + 1] = bookmark end

		if save_bookmarks(root, bookmarks) then
			local action = updated and "Updated" or "Added"
			vim.notify(string.format("[bookmark-jump.nvim] %s %s", action, display_text(bookmark)))
		end
	end)
end

function M.find()
	local root = current_location(true)
	if not root then return end

	local bookmarks = load_bookmarks(root)
	if not bookmarks then return end

	require("snacks")
		.picker({
			title = "Bookmarks",
			finder = function() return picker_items(root, bookmarks) end,
			format = "text",
			preview = function(ctx)
				local ok, lines = pcall(vim.fn.readfile, ctx.item.file)
				ctx.preview:set_lines(ok and lines or { "Unable to read " .. ctx.item.file })

				local filetype = vim.filetype.match({ filename = ctx.item.file })
				if filetype then vim.bo[ctx.preview.win.buf].filetype = filetype end
				ctx.preview:loc()
			end,
			confirm = function(picker, item, action)
				picker:close()
				local command = action and ({ split = "split", vsplit = "vsplit" })[action.cmd]
				open_bookmark(item, command)
			end,
			actions = {
				delete_bookmark = function(picker, item)
					if not item then return end
					local bookmark = table.remove(bookmarks, item.bookmark_index)
					if not bookmark then return end
					if not save_bookmarks(root, bookmarks) then
						table.insert(bookmarks, item.bookmark_index, bookmark)
						return
					end
					picker:refresh()
				end,
			},
			win = {
				input = {
					keys = {
						["<C-x>"] = { "delete_bookmark", mode = { "i", "n" }, desc = "Delete bookmark" },
					},
				},
				list = {
					keys = {
						["<C-x>"] = { "delete_bookmark", desc = "Delete bookmark" },
					},
				},
			},
		})
		:find()
end

return M
