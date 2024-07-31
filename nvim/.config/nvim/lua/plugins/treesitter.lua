return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
        local config = require("nvim-treesitter.configs")

        config.setup({
            ensure_installed = {
                "c",
                "bash",
                "cpp",
                "lua",
                "javascript",
                "typescript",
                "gdscript",
                "godot_resource",
                "gdshader"
            },
            auto_install = true,
            highlight = { enabled = true },
            indent = { enabled = true },
        })
    end,
}
