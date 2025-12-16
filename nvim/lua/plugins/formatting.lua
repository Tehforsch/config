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
			python = { "ruff_format" },
			nix = { "alejandra" },
			lua = { "stylua" },
			yaml = { "prettier" },
			json = { "prettier" },
			markdown = { "prettier" },
		},
		format_on_save = nil,
	},
}
