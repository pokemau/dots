return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",

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
					-- INACTIVE BUFFERS (not visible in any window) - most dimmed
					background = {
						fg = { attribute = "fg", highlight = "Comment" },
						bg = { attribute = "bg", highlight = "Normal" },
					},

					-- VISIBLE BUFFERS (in another window, not selected) - less dimmed
					buffer_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},

					-- SELECTED BUFFER (active/current) - HIGHER CONTRAST TEXT
					buffer_selected = {
						fg = "#ebdbb2", -- Bright Gruvbox white (change to "#ffffff" for pure white)
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
						italic = false,
					},

					-- SEPARATORS - invisible/minimal
					separator = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					separator_visible = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					separator_selected = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
					},

					-- INDICATORS
					indicator_visible = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					indicator_selected = {
						fg = "#ebdbb2", -- Bright text
						bg = { attribute = "bg", highlight = "ColorColumn" },
					},

					-- CLOSE BUTTONS
					close_button = {
						fg = { attribute = "fg", highlight = "Comment" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					close_button_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					close_button_selected = {
						fg = "#ebdbb2", -- Bright text
						bg = { attribute = "bg", highlight = "ColorColumn" },
					},

					-- MODIFIED INDICATORS (Left as String highlight for color coding)
					modified = {
						fg = { attribute = "fg", highlight = "String" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					modified_visible = {
						fg = { attribute = "fg", highlight = "String" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					modified_selected = {
						fg = { attribute = "fg", highlight = "String" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
					},

					-- DUPLICATE BUFFERS
					duplicate = {
						fg = { attribute = "fg", highlight = "Comment" },
						bg = { attribute = "bg", highlight = "Normal" },
						italic = true,
					},
					duplicate_visible = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
						italic = true,
					},
					duplicate_selected = {
						fg = "#ebdbb2", -- Bright text
						bg = { attribute = "bg", highlight = "ColorColumn" },
						italic = true,
					},

					-- DIAGNOSTICS: ERROR (Kept color coding)
					error = {
						fg = { attribute = "fg", highlight = "DiagnosticError" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					error_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticError" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					error_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticError" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},
					error_diagnostic = {
						fg = { attribute = "fg", highlight = "DiagnosticError" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					error_diagnostic_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticError" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					error_diagnostic_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticError" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},

					-- DIAGNOSTICS: WARNING (Kept color coding)
					warning = {
						fg = { attribute = "fg", highlight = "DiagnosticWarn" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					warning_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticWarn" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					warning_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticWarn" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},
					warning_diagnostic = {
						fg = { attribute = "fg", highlight = "DiagnosticWarn" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					warning_diagnostic_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticWarn" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					warning_diagnostic_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticWarn" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},

					-- DIAGNOSTICS: INFO (Kept color coding)
					info = {
						fg = { attribute = "fg", highlight = "DiagnosticInfo" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					info_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticInfo" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					info_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticInfo" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},
					info_diagnostic = {
						fg = { attribute = "fg", highlight = "DiagnosticInfo" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					info_diagnostic_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticInfo" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					info_diagnostic_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticInfo" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},

					-- DIAGNOSTICS: HINT (Kept color coding)
					hint = {
						fg = { attribute = "fg", highlight = "DiagnosticHint" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					hint_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticHint" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					hint_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticHint" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},
					hint_diagnostic = {
						fg = { attribute = "fg", highlight = "DiagnosticHint" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					hint_diagnostic_visible = {
						fg = { attribute = "fg", highlight = "DiagnosticHint" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
					hint_diagnostic_selected = {
						fg = { attribute = "fg", highlight = "DiagnosticHint" },
						bg = { attribute = "bg", highlight = "ColorColumn" },
						bold = true,
					},
				},
			})

			vim.keymap.set("n", "<A-S-l>", ":BufferLineMoveNext<CR>", { silent = true })
			vim.keymap.set("n", "<A-S-h>", ":BufferLineMovePrev<CR>", { silent = true })
			vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { silent = true })
			vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { silent = true })
		end,
	},
}
