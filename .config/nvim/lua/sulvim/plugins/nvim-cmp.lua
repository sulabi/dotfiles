local nvim_cmp = {
	{
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"onsails/lspkind.nvim",
		"rafamadriz/friendly-snippets",
	},

	config = function(_, opts)
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		cmp.setup({
			experimental = {
				ghost_text = false,
			},
			completion = {
				completeopt = "menu,menuone,noinsert",
			},

			snippet = {
				expand = function(args) luasnip.lsp_expand(args.body) end,
			},

			sources = cmp.config.sources({
				{ name = "luasnip", group_index = 1 }, -- snippets
				{ name = "nvim_lsp", group_index = 1 },
				{ name = "buffer", group_index = 2 }, -- text within current buffer
				{ name = "path", group_index = 2 }, -- file system paths
				{
					name = "spell", -- for markdown spellchecks completions
					group_index = 2,
					option = {
						enable_in_context = function()
							local ft = vim.bo.filetype
							return ft == "markdown" or ft == "text"
						end,
					},
				},
			}),
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},

			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					menu = {
						nvim_lsp = "[LSP]",
						luasnip = "[Snip]",
						buffer = "[Buf]",
						path = "[Path]",
					},
				}),
			},
			window = {
				completion = cmp.config.window.bordered({
					border = "rounded",
				}),
				documentation = cmp.config.window.bordered({
					border = "rounded",
				}),
			},

			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.close()
					else
						cmp.complete()
					end
				end),
				["<C-e>"] = cmp.mapping.abort(),

				["<CR>"] = cmp.mapping.confirm({
					select = false,
				}),

				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline({
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "c" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "c" })
			}),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})

		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}

return nvim_cmp
