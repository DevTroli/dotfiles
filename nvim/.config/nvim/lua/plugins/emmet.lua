return {
	"mattn/emmet-vim",
	init = function()
		vim.g.user_emmet_leader_key = "<C-e>"
		vim.g.user_emmet_settings = {
			php = { extends = "html" },
		}
	end,
	config = function()
		vim.keymap.set("i", ";;", "<plug>(emmet-expand-abbr)", { silent = true })
	end,
}
