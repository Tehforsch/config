return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			",f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			rust = { "rustfmt" },
			python = { "black" },
			nix = { "alejandra" },
			haskell = { "fourmolu" },
			lua = { "stylua" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			yaml = { "prettier" },
			json = { "prettier" },
			markdown = { "prettier" },
		},
		formatters = {
			rustfmt = {
				command = "rustfmt",
				args = { "--edition", "2021" },
			},
			clang_format = {
				command = "clang-format",
				args = { "-style=file" },
			},
		},
		format_on_save = nil,
	},
}
