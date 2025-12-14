return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function project_relative_path()
        local filepath = vim.fn.expand('%:p')
        if filepath == '' then
          return '[No Name]'
        end

        -- Get the project root from project.nvim
        local project = require('project_nvim.project')
        local project_root = project.get_project_root()

        if project_root then
          -- Make path relative to project root
          local relative = filepath:gsub('^' .. vim.pesc(project_root) .. '/', '')
          return relative
        else
          -- Fall back to filename if not in a project
          return vim.fn.expand('%:t')
        end
      end

      require('lualine').setup({
        options = {
          theme = 'gruvbox',
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              project_relative_path,
              color = { gui = 'bold' },
            },
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  },
}
