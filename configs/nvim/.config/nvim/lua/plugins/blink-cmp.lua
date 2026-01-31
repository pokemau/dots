-- return {}
return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
						require("luasnip.loaders.from_vscode").lazy_load({
							paths = { vim.fn.stdpath("config") .. "/snippets" },
						})
					end,
				},
			},
		},
		"onsails/lspkind.nvim",
		"folke/lazydev.nvim",
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			preset = "enter",
		},

		appearance = {
			nerd_font_variant = "normal",
		},

		completion = {
			menu = {
				auto_show = true,
				draw = {
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
				-- border = "single",
        auto_show_delay_ms = 0,
				-- auto_show = function(ctx, items)
				-- 	local ft = vim.bo.filetype
				-- 	return vim.tbl_contains({ "typescript", "javascript", "typescriptreact", "javascriptreact", "html" }, ft)
				-- end,
			},
			documentation = {
				window = {
					-- border = "single",
				},
			},
		},

		-- completion = {
		--   menu = {
		--     auto_show = true,
		--     draw = {
		--       columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
		--     },
		--   },
		--   documentation = { auto_show = true, auto_show_delay_ms = 100 },
		-- },
		--
		sources = {
			-- default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			default = { "lsp", "lazydev" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "lua" },

		signature = {
			enabled = false,
			trigger = {
				enabled = true,
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_insert = true,
				show_on_insert_on_trigger_character = true,
			},
			window = {
				border = "single",
				treesitter_highlighting = true,
			},
		},
	},
}
