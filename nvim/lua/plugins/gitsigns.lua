return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		attach_to_untracked = true,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
		},
		sign_priority = 6,
		update_debounce = 100,
		max_file_length = 40000,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			vim.keymap.set("n", "<leader>gb", function()
				gs.toggle_current_line_blame()
			end, { buffer = bufnr, desc = "Toggle git blame" })

			local function browse_revision_files()
				local function get_refs()
					local refs = {}
					for _, branch in ipairs(vim.fn.systemlist("git branch -a --format='%(refname:short)'")) do
						table.insert(refs, { text = "  " .. branch, ref = branch })
					end
					for _, tag in ipairs(vim.fn.systemlist("git tag")) do
						table.insert(refs, { text = "  " .. tag, ref = tag })
					end
					for _, commit in ipairs(vim.fn.systemlist("git log --pretty=format:'%h %s' -n 20")) do
						local hash, msg = commit:match("^(%S+)%s+(.*)$")
						if hash then
							table.insert(refs, { text = "  " .. hash .. " " .. msg, ref = hash })
						end
					end
					return refs
				end

				Snacks.picker.pick({
					title = "Browse Revision",
					items = get_refs(),
					confirm = function(p1, item)
						p1:close()
						local rev = item.ref
						local files = vim.fn.systemlist("git ls-tree -r --name-only " .. rev)
						if vim.v.shell_error ~= 0 then
							vim.notify("Failed to list files at revision " .. rev, vim.log.levels.ERROR)
							return
						end
						Snacks.picker.pick({
							title = "Files at " .. rev,
							items = vim.tbl_map(function(f)
								return { text = f, file = f, rev = rev }
							end, files),
							preview = function(ctx)
								local ft = vim.filetype.match({ filename = ctx.item.file })
								Snacks.picker.preview.cmd(
									{ "git", "show", ctx.item.rev .. ":" .. ctx.item.file },
									ctx,
									{ ft = ft }
								)
							end,
							confirm = function(p2, item2)
								p2:close()
								local content = vim.fn.systemlist("git show " .. item2.rev .. ":" .. item2.file)
								local buf = vim.api.nvim_create_buf(false, true)
								vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
								vim.api.nvim_buf_set_name(buf, item2.file .. " @ " .. rev)
								vim.bo[buf].buftype = "nofile"
								vim.bo[buf].modifiable = false
								local ft = vim.filetype.match({ filename = item2.file })
								if ft then vim.bo[buf].filetype = ft end
								vim.api.nvim_set_current_buf(buf)
							end,
						})
					end,
				})
			end

			vim.keymap.set("n", "<leader>gf", browse_revision_files, { buffer = bufnr, desc = "Browse files at revision" })

			vim.keymap.set("n", "<leader>gs", function()
				local root = vim.fn.system("jj root"):gsub("\n$", "")
				if vim.v.shell_error ~= 0 then
					vim.notify("Not a jj repo", vim.log.levels.ERROR)
					return
				end
				local diff_output = vim.fn.system("jj diff --git")
				if vim.v.shell_error ~= 0 or diff_output == "" then
					vim.notify("No changes found", vim.log.levels.INFO)
					return
				end
				Snacks.picker.pick({
					title = "Working Copy Hunks",
					finder = function(opts, ctx)
						return require("snacks.picker.source.diff").diff(
							vim.tbl_extend("force", opts, { diff = diff_output, cwd = root }),
							ctx
						)
					end,
					format = "file",
					preview = "diff",
				})
			end, { buffer = bufnr, desc = "Browse working copy hunks" })

			local Hydra = require("hydra")
			Hydra({
				name = "Git hunk navigation",
				mode = "n",
				body = "<leader>g",
				hint = [[
 _n_: next hunk   _p_: prev hunk
]],
				config = {
					color = "pink",
					invoke_on_body = false,
					hint = {
						float_opts = {
							border = "rounded",
						},
						position = "bottom",
					},
				},
				heads = {
					{
						"n",
						function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gs.next_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true, desc = "next hunk" },
					},
					{
						"p",
						function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gs.prev_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true, desc = "prev hunk" },
					},
					{ "<Esc>", nil, { exit = true } },
					{ "b", gs.toggle_current_line_blame, { exit = true, desc = "toggle blame" } },
				},
			})
		end,
	},
}
