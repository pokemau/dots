-- VSCode Dark+ color palette used throughout
-- fill/bar:   #111213
-- tab bg:     #17191A (inactive), #3c3c3c (selected)
-- fg normal:  #d4d4d4, fg muted: #969696, fg active: #ffffff
-- diagnostics: error #f44747, warn #cca700, info #75beff, hint #b5cea8

return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "Mofiqul/vscode.nvim" },

		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup({

				options = {
					diagnostics = "nvim_lsp",
					indicator = {
						style = "none",
					},
				},

				highlights = {
					background = {
						fg = "#969696",
						bg = "#17191A",
					},

					buffer_visible = {
						fg = "#d4d4d4",
						bg = "#17191A",
					},

					-- SELECTED BUFFER (active/current)
					buffer_selected = {
						fg = "#ffffff",
						bg = "#3c3c3c",
						bold = true,
						italic = false,
					},

					-- SEPARATORS - invisible/minimal
					separator = {
						fg = "#17191A",
						bg = "#17191A",
					},
					separator_visible = {
						fg = "#17191A",
						bg = "#17191A",
					},
					separator_selected = {
						fg = "#3c3c3c",
						bg = "#3c3c3c",
					},

					-- INDICATORS
					indicator_visible = {
						fg = "#17191A",
						bg = "#17191A",
					},
					indicator_selected = {
						fg = "#3c3c3c",
						bg = "#3c3c3c",
					},

					-- CLOSE BUTTONS
					close_button = {
						fg = "#969696",
						bg = "#17191A",
					},
					close_button_visible = {
						fg = "#d4d4d4",
						bg = "#17191A",
					},
					close_button_selected = {
						fg = "#ffffff",
						bg = "#3c3c3c",
					},

					-- MODIFIED INDICATORS
					modified = {
						fg = "#ce9178",
						bg = "#17191A",
					},
					modified_visible = {
						fg = "#ce9178",
						bg = "#17191A",
					},
					modified_selected = {
						fg = "#ce9178",
						bg = "#3c3c3c",
					},

					-- DUPLICATE BUFFERS
					duplicate = {
						fg = "#969696",
						bg = "#17191A",
						italic = true,
					},
					duplicate_visible = {
						fg = "#d4d4d4",
						bg = "#17191A",
						italic = true,
					},
					duplicate_selected = {
						fg = "#ffffff",
						bg = "#3c3c3c",
						italic = true,
					},

					-- DIAGNOSTICS: ERROR
					error = {
						fg = "#f44747",
						bg = "#17191A",
					},
					error_visible = {
						fg = "#f44747",
						bg = "#17191A",
					},
					error_selected = {
						fg = "#f44747",
						bg = "#3c3c3c",
						bold = true,
					},
					error_diagnostic = {
						fg = "#f44747",
						bg = "#17191A",
					},
					error_diagnostic_visible = {
						fg = "#f44747",
						bg = "#17191A",
					},
					error_diagnostic_selected = {
						fg = "#f44747",
						bg = "#3c3c3c",
						bold = true,
					},

					-- DIAGNOSTICS: WARNING
					warning = {
						fg = "#cca700",
						bg = "#17191A",
					},
					warning_visible = {
						fg = "#cca700",
						bg = "#17191A",
					},
					warning_selected = {
						fg = "#cca700",
						bg = "#3c3c3c",
						bold = true,
					},
					warning_diagnostic = {
						fg = "#cca700",
						bg = "#17191A",
					},
					warning_diagnostic_visible = {
						fg = "#cca700",
						bg = "#17191A",
					},
					warning_diagnostic_selected = {
						fg = "#cca700",
						bg = "#3c3c3c",
						bold = true,
					},

					-- DIAGNOSTICS: INFO
					info = {
						fg = "#75beff",
						bg = "#17191A",
					},
					info_visible = {
						fg = "#75beff",
						bg = "#17191A",
					},
					info_selected = {
						fg = "#75beff",
						bg = "#3c3c3c",
						bold = true,
					},
					info_diagnostic = {
						fg = "#75beff",
						bg = "#17191A",
					},
					info_diagnostic_visible = {
						fg = "#75beff",
						bg = "#17191A",
					},
					info_diagnostic_selected = {
						fg = "#75beff",
						bg = "#3c3c3c",
						bold = true,
					},

					-- DIAGNOSTICS: HINT
					hint = {
						fg = "#b5cea8",
						bg = "#17191A",
					},
					hint_visible = {
						fg = "#b5cea8",
						bg = "#17191A",
					},
					hint_selected = {
						fg = "#b5cea8",
						bg = "#3c3c3c",
						bold = true,
					},
					hint_diagnostic = {
						fg = "#b5cea8",
						bg = "#17191A",
					},
					hint_diagnostic_visible = {
						fg = "#b5cea8",
						bg = "#17191A",
					},
					hint_diagnostic_selected = {
						fg = "#b5cea8",
						bg = "#3c3c3c",
						bold = true,
					},
				},
			})

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					local fill_bg = "#111213"
					local tab_bg = "#17191A"
					local sel_bg = "#3c3c3c"
					vim.api.nvim_set_hl(0, "BufferLineFill", { bg = fill_bg })
					vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = tab_bg, bg = tab_bg })
					vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = sel_bg, bg = sel_bg })
					vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = tab_bg, bg = tab_bg })
					vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = sel_bg, bg = sel_bg })
				end,
			})
			local fill_bg = "#111213"
			local tab_bg = "#17191A"
			local sel_bg = "#3c3c3c"
			vim.api.nvim_set_hl(0, "BufferLineFill", { bg = fill_bg })
			vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = tab_bg, bg = tab_bg })
			vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = sel_bg, bg = sel_bg })
			vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = tab_bg, bg = tab_bg })
			vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = sel_bg, bg = sel_bg })

			vim.keymap.set("n", "<A-S-l>", ":BufferLineMoveNext<CR>", { silent = true })
			vim.keymap.set("n", "<A-S-h>", ":BufferLineMovePrev<CR>", { silent = true })
			vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { silent = true })
			vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { silent = true })
		end,
	},
}
