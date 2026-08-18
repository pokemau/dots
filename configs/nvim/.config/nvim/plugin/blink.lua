vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

require('blink.cmp').setup({
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = {
    enabled = true,
    window = {
      show_documentation = true
    }
  },
  keymap = {
    preset = "enter",
    -- ["<C-space>"] = {},
    -- ["<C-p>"] = {},
    -- ["<Tab>"] = {},
    -- ["<S-Tab>"] = {},
    -- ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
    -- ["<C-n>"] = { "select_and_accept" },
    -- ["<C-k>"] = { "select_prev", "fallback" },
    -- ["<C-j>"] = { "select_next", "fallback" },
    -- ["<C-b>"] = { "scroll_documentation_down", "fallback" },
    -- ["<C-f>"] = { "scroll_documentation_up", "fallback" },
    -- ["<C-l>"] = { "snippet_forward", "fallback" },
    -- ["<C-h>"] = { "snippet_backward", "fallback" },
    -- ["<C-e>"] = { "hide" },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "normal",
  },

  completion = {
    menu = {

      auto_show = function()
        local ft = vim.bo.filetype
        local buf_name = vim.api.nvim_buf_get_name(0) or ""

        -- do not show cmp for c/cpp files
        if vim.tbl_contains({ "c", "c++", "cpp" }, ft) then
          return false
        end

        -- do not show for leetcode nvim
        if ft == "python" and type(buf_name) == "string" and buf_name:match("leetcode") then
          return false
        end

        return true
      end,

      draw = {
        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    }
  },

  cmdline = {
    keymap = {
      preset = 'inherit',
      ['<CR>'] = { 'accept_and_enter', 'fallback' },
    },
  },

  sources = { default = { "lsp" } }
})
