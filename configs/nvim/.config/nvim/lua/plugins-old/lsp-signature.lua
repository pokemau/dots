-- return{}
return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	opts = {
		bind = true,
    doc_lines = 0,
		handler_opts = {
			border = "rounded",
		},
		hint_enable = true,
    hint_prefix = "",

    floating_window = false,
		floating_window_above_cur_line = true,
	},
}
