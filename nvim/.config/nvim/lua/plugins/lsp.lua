-- return {}
return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    }, {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "tsserver",
            },
        })
    end,
},
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16"
                }
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities
            })

            lspconfig.glsl_analyzer.setup({
                capabilities = capabilities
            })

            lspconfig.gdscript.setup({
                capabilities = capabilities
            })


            vim.keymap.set('n', '<C-p>', vim.lsp.buf.signature_help, {})
            vim.keymap.set('i', '<C-p>', vim.lsp.buf.signature_help, {})
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
            vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
        end,
    },
}
