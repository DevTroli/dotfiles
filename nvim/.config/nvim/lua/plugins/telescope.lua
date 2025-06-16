return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")

			telescope.setup({
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					path_display = { "smart" },
					layout_strategy = "horizontal",
					layout_config = {
						prompt_position = "top",
						width = 0.50,
						height = 0.50,
					},
					sorting_strategy = "ascending",
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			telescope.load_extension("fzf")

			local opts = { noremap = true, silent = true }

			-- Find files (dropdown, sem preview)
			vim.keymap.set("n", "<C-f>", function()
				builtin.find_files(themes.get_dropdown({ previewer = false }))
			end, opts)

			-- Buffers (dropdown, sem preview)
			vim.keymap.set("n", "<C-b>", function()
				builtin.buffers(themes.get_dropdown({ previewer = false }))
			end, opts)

			-- Live grep (preview ativado)
			vim.keymap.set("n", "<C-g>", function()
				builtin.live_grep()
			end, opts)

			-- Help tags (preview ativado)
			vim.keymap.set("n", "<leader>H", function()
				builtin.help_tags()
			end, opts)
		end,
	},
}
