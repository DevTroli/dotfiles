return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "catppuccin/nvim" },
  config = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    local minimal_theme = {
      normal = {
        a = { fg = mocha.base, bg = mocha.green, gui = "bold" },
        b = { fg = mocha.green, bg = mocha.base },
        c = { fg = mocha.text, bg = mocha.base },
      },
      insert = {
        a = { fg = mocha.base, bg = mocha.green, gui = "bold" },
        b = { fg = mocha.green, bg = mocha.base },
        c = { fg = mocha.text, bg = mocha.base },
      },
      visual = {
        a = { fg = mocha.base, bg = mocha.lavender, gui = "bold" },
        b = { fg = mocha.lavender, bg = mocha.base },
        c = { fg = mocha.text, bg = mocha.base },
      },
      command = {
        a = { fg = mocha.base, bg = mocha.yellow, gui = "bold" },
        b = { fg = mocha.yellow, bg = mocha.base },
        c = { fg = mocha.text, bg = mocha.base },
      },
      replace = {
        a = { fg = mocha.base, bg = mocha.red, gui = "bold" },
        b = { fg = mocha.red, bg = mocha.base },
        c = { fg = mocha.text, bg = mocha.base },
      },
      inactive = {
        a = { fg = mocha.overlay2, bg = mocha.surface1, gui = "bold" },
        b = { fg = mocha.overlay2, bg = mocha.surface1 },
        c = { fg = mocha.overlay2, bg = mocha.surface1 },
      },
    }

    require("lualine").setup({
      options = {
        theme = minimal_theme,
        section_separators = "",
        component_separators = "",
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "neo-tree" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "fugitive", "quickfix" },
    })
  end,
}

