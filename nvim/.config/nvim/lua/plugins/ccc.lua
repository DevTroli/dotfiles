return {
  "uga-rosa/ccc.nvim",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    local ccc = require("ccc")

    ccc.setup({
      highlighter = {
        auto_enable = true,
        lsp = true,
        excludes = { "lazy", "mason", "help", "neo-tree" },
      },

      pickers = {
        ccc.picker.hex,
        ccc.picker.css_rgb,
        ccc.picker.css_hsl,
      },

      inputs = {
        ccc.input.rgb,
        ccc.input.hsl,
        ccc.input.cmyk,
      },

      outputs = {
        ccc.output.hex,
        ccc.output.css_rgb,
        ccc.output.css_hsl,
      },

      alpha_show = "auto",
      recognize = {
        input = true,
        output = true,
      },

      -- Catppuccin Mocha integration
      bar_char = "█",
      point_char = "◦",
      bar_len = 30,
      win_opts = {
        border = "rounded",
      },

      auto_close = true,
      preserve = false,
      save_on_quit = false,
    })

    -- Keymaps
    local map = vim.keymap.set

    map("n", "<leader>cp", "<cmd>CccPick<cr>", { desc = "Color picker" })
    map("n", "<leader>ct", "<cmd>CccHighlighterToggle<cr>", { desc = "Toggle color highlight" })
    map("n", "<leader>cc", "<cmd>CccConvert<cr>", { desc = "Convert color format" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "css", "scss", "sass", "less", "stylus", "html", "javascript", "typescript", "vue", "svelte" },
      callback = function()
        require("ccc").highlighter.enable()
      end,
    })
  end,
}
