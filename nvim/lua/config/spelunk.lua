local M = {}

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
			if name then return "function " .. vim.treesitter.get_node_text(name, 0) end

			local row = node:range()
			return source_line(vim.api.nvim_buf_get_name(0), row + 1)
		end
		node = node:parent()
	end
end

local function bookmark_items(data)
	local items = {}
	for _, mark in ipairs(data) do
		local context = mark.meta.context or source_line(mark.file, mark.line)
		local text = string.format("[%s] %s:%d:%d", mark.stack, vim.fn.fnamemodify(mark.file, ":."), mark.line, mark.col)
		if context then text = text .. "  " .. context end

		items[#items + 1] = vim.tbl_extend("force", mark, {
			text = text,
			pos = { mark.line, mark.col },
		})
	end
	return items
end

local function same_mark(left, right) return left.stack == right.stack and left.file == right.file and left.line == right.line and left.col == right.col end

local function delete_bookmark(picker, item, data)
	if not item then return end

	local markmgr = require("spelunk.markmgr")
	local stack_idx = markmgr.stack_idx_for_name(item.stack)
	if stack_idx < 0 then return end

	local mark_idx
	for idx, mark in ipairs(markmgr.physical_stack(stack_idx).bookmarks) do
		if mark.file == item.file and mark.line == item.line and mark.col == item.col then
			mark_idx = idx
			break
		end
	end
	if not mark_idx then return end

	markmgr.delete_mark(stack_idx, mark_idx)
	require("spelunk").persist()

	for idx, mark in ipairs(data) do
		if same_mark(mark, item) then
			table.remove(data, idx)
			break
		end
	end
	picker:refresh()
end

local function search_marks(opts)
	require("snacks")
		.picker({
			title = opts.prompt,
			finder = function() return bookmark_items(opts.data) end,
			format = "text",
			preview = function(ctx)
				local ok, lines = pcall(vim.fn.readfile, ctx.item.file)
				ctx.preview:set_lines(ok and lines or { "Unable to read " .. ctx.item.file })

				local ft = vim.filetype.match({ filename = ctx.item.file })
				if ft then vim.bo[ctx.preview.win.buf].filetype = ft end
				ctx.preview:loc()
			end,
			confirm = function(picker, item, action)
				picker:close()
				local split = action and ({ split = "horizontal", vsplit = "vertical" })[action.cmd]
				opts.select_fn(item.file, item.line, item.col, split)
			end,
			actions = {
				delete_bookmark = function(picker, item) delete_bookmark(picker, item, opts.data) end,
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

function M.add_bookmark()
	local spelunk = require("spelunk")
	local markmgr = require("spelunk.markmgr")
	local stack_idx = spelunk.get_current_stack_index()
	local mark_count = markmgr.len_marks(stack_idx)
	local context = function_context() or source_line(vim.api.nvim_buf_get_name(0), vim.fn.line("."))

	spelunk.add_bookmark()
	if markmgr.len_marks(stack_idx) == mark_count + 1 and context then
		markmgr.add_mark_meta(stack_idx, mark_count + 1, "context", context)
		spelunk.persist()
	end
end

function M.setup() require("spelunk.fuzzy.snacks").search_marks = search_marks end

return M
