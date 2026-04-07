vim.pack.add({'https://github.com/Mofiqul/vscode.nvim'})

-- Lua:
-- For dark theme (neovim's default)
vim.o.background = 'dark'

local c = require('vscode.colors').get_colors()
require('vscode').setup({
    transparent = false,
    italic_comments = false,
    italic_inlayhints = false,
    underline_links = true,
    disable_nvimtree_bg = true,

    -- Apply theme colors to terminal
    terminal_colors = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },

				Normal = { bg = "#17191A" },
				NormalFloat = { bg = "#1e1e1e" },
				FloatBorder = { bg = "#1e1e1e", fg = "#3e3e3e" },
				Pmenu = { bg = "#1e1e1e" },
				PmenuSel = { bg = "#264f78" },
    }
})
-- require('vscode').load()
vim.cmd.colorscheme("vscode")
