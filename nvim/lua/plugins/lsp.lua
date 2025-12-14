return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gp", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    vim.lsp.config("*", {
      root_markers = { ".git" },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.enable("rust_analyzer")
    vim.lsp.config.rust_analyzer = {
      cmd = { "rust-analyzer" },
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            targetDir = "target/ra",
          },
          check = {
            command = "clippy",
          },
        },
      },
    }

    vim.lsp.enable("pyright")

    vim.lsp.enable("clangd")

    vim.lsp.enable("nil_ls")

    vim.lsp.enable("hls")

    vim.lsp.enable("lua_ls")
    vim.lsp.config.lua_ls = {
      cmd = { "lua-language-server" },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    }
  end,
}
