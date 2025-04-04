return {
  "neovim/nvim-lspconfig",
  opts = function()
    local ret = {
      inlay_hints = {
        enabled = false,
      },
    }
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    keys[#keys + 1] = { "<leader> p", "signature_help" }

    return ret
  end,
}
