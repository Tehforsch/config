return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					-- C-p to manually trigger completion
					["<C-p>"] = cmp.mapping.complete(),

					-- C-j/C-k to navigate items
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

					-- Tab to confirm completion
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Scroll documentation
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),

					-- Close completion menu
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
                        -- Hide snippets in autocomletion
						entry_filter = function(entry, ctx)
							return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
						end,
					},
					{ name = "path" },
				}, {
					{ name = "buffer", keyword_length = 3 },
				}),
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						function(entry1, entry2)
							local kind1 = entry1:get_kind()
							local kind2 = entry2:get_kind()
							local priority = {
								[cmp.lsp.CompletionItemKind.Field] = 1,
								[cmp.lsp.CompletionItemKind.Property] = 1,
								[cmp.lsp.CompletionItemKind.EnumMember] = 1,
								[cmp.lsp.CompletionItemKind.Method] = 2,
								[cmp.lsp.CompletionItemKind.Function] = 2,
							}
							local p1 = priority[kind1] or 3
							local p2 = priority[kind2] or 3
							if p1 ~= p2 then
								return p1 < p2
							end
						end,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, item)
						local menu_icon = {
							nvim_lsp = "[LSP]",
							buffer = "[Buf]",
							path = "[Path]",
						}
						item.menu = menu_icon[entry.source.name]
						return item
					end,
				},
				performance = {
					max_view_entries = 20,
				},
			})

			-- Command line completion
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Search completion
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
		end,
	},
}
