return {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('lean').setup({
      mappings = false,
      infoview = {
        autoopen = true,
        width = 50,
        height = 20,
        horizontal_position = 'bottom',
        separate_tab = false,
      },
      abbreviations = {
        builtin = true,
        leader = '\\',
      },
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'lean',
      callback = function(ev)
        vim.keymap.set('i', 'ß', '\\', { buffer = ev.buf, noremap = true, silent = true })
        vim.keymap.set('n', '<localleader>v', ':LeanInfoviewToggle<CR>', { buffer = ev.buf, noremap = true, silent = true, desc = 'Toggle Lean infoview' })
      end,
    })
  end,
}
