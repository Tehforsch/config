local M = {}

vim.api.nvim_set_hl(0, "WinBarProject", { link = "GruvboxAqua" })
vim.api.nvim_set_hl(0, "WinBarFilename", { link = "GruvboxYellow" })

function M.winbar()
	local project_name = ""

	local ok, project = pcall(require, "project_nvim.project")
	if ok then
		local project_root = project.get_project_root()
		if project_root then
			project_name = vim.fn.fnamemodify(project_root, ":t")
		end
	end

	local filename = "%f"
	local modified = "%m"

	if project_name ~= "" then
		return string.format("%%#WinBarProject#[%s]%%* %%#WinBarFilename#%s%%* %s", project_name, filename, modified)
	else
		return string.format("%%#WinBarFilename#%s%%* %s", filename, modified)
	end
end

return M
