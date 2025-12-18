return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
		"nvimtools/hydra.nvim",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		vim.keymap.del("n", "grr", { buffer = false })
		vim.keymap.del("n", "gra", { buffer = false })
		vim.keymap.del("n", "grn", { buffer = false })
		vim.keymap.del("n", "gri", { buffer = false })
		vim.keymap.del("n", "grt", { buffer = false })
		vim.keymap.del("x", "gra", { buffer = false })

		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "gd", function()
				require("telescope.builtin").lsp_definitions()
			end, opts)
			vim.keymap.set("n", "gr", function()
				require("telescope.builtin").lsp_references()
			end, opts)
			vim.keymap.set("n", "gtt", function()
				require("telescope.builtin").lsp_type_definitions()
			end, opts)
			vim.keymap.set("n", "gti", function()
				require("telescope.builtin").lsp_implementations()
			end, opts)
			vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
			vim.keymap.set({ "n", "v" }, "<localleader>x", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

			if vim.bo[bufnr].filetype == "rust" then
				vim.keymap.set("n", "<localleader>p", function()
					vim.lsp.buf_request(bufnr, "experimental/parentModule", vim.lsp.util.make_position_params(), function(_, result)
						if not result or vim.tbl_isempty(result) then
							vim.notify("No parent module found", vim.log.levels.INFO)
							return
						end
						vim.lsp.util.jump_to_location(result[1], "utf-8")
					end)
				end, vim.tbl_extend("force", opts, { desc = "Go to parent module" }))
			end
		end

		vim.keymap.set("n", "<localleader>el", function()
			require("telescope.builtin").diagnostics()
		end, { desc = "List diagnostics" })

		local Hydra = require("hydra")
		Hydra({
			name = "Diagnostics",
			mode = "n",
			body = "<localleader>e",
			heads = {
				{
					"n",
					function()
						vim.diagnostic.goto_next()
					end,
					{ desc = "next diagnostic" },
				},
				{
					"p",
					function()
						vim.diagnostic.goto_prev()
					end,
					{ desc = "prev diagnostic" },
				},
				{
					"l",
					function()
						require("telescope.builtin").diagnostics()
					end,
					{ exit = true, desc = "list diagnostics" },
				},
				{ "q", nil, { exit = true, desc = "quit" } },
				{ "<Esc>", nil, { exit = true, desc = "quit" } },
			},
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			virtual_text = false,
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

		vim.keymap.set("n", "<localleader>es", function()
			vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
		end, { desc = "Show diagnostic" })

		vim.lsp.config("*", {
			root_markers = { ".git" },
			capabilities = capabilities,
			on_attach = on_attach,
		})

		vim.lsp.enable("rust_analyzer")
		vim.lsp.config.rust_analyzer = {
			cmd = { "rust-analyzer" },
			capabilities = capabilities,
			on_attach = on_attach,
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
			capabilities = capabilities,
			on_attach = on_attach,
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
