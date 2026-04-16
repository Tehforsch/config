return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
		config = function()
			vim.treesitter.language.register("rust", "molt")

			local ensure_installed = {
				"rust",
				"python",
				"c",
				"lua",
				"nix",
				"haskell",
				"yaml",
				"wgsl",
				"ron",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
			}
			local already_installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(already_installed, parser)
				end)
				:totable()
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select").select_textobject
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			vim.keymap.set({ "x", "o" }, "af", function() select("@function.outer", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "if", function() select("@function.inner", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "ac", function() select("@class.outer", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "ic", function() select("@class.inner", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "aa", function() select("@parameter.outer", "textobjects") end)
			vim.keymap.set({ "x", "o" }, "ia", function() select("@parameter.inner", "textobjects") end)

			vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "L", function() move.goto_next_start("@parameter.inner", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "H", function() move.goto_previous_start("@parameter.inner", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)

			vim.keymap.set("n", "gL", function() swap.swap_next("@parameter.inner") end)
			vim.keymap.set("n", "gH", function() swap.swap_previous("@parameter.inner") end)
		end,
	},
}
