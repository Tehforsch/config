return {
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        detection_methods = { 'pattern', 'lsp' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'Cargo.toml', 'flake.nix' },

        show_hidden = false,
        silent_chdir = false,
        scope_chdir = 'global',

        datapath = vim.fn.stdpath('data'),

        exclude_dirs = {},

        manual_mode = false,
      })

      local projects_dir = vim.fn.expand('~/projects')
      if vim.fn.isdirectory(projects_dir) == 1 then
        local scan_command = string.format('fd -t d -d 1 --absolute-path . %s', projects_dir)
        local handle = io.popen(scan_command)
        if handle then
          for dir in handle:lines() do
            if vim.fn.isdirectory(dir .. '/.git') == 1 then
              vim.fn.mkdir(vim.fn.stdpath('data') .. '/project_nvim', 'p')
            end
          end
          handle:close()
        end
      end

      require('telescope').load_extension('projects')
    end,
  },
}
