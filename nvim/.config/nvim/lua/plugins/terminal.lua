return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()

    require("toggleterm").setup({
      open_mapping = [[<c-/>]],
      shade_terminals = true,
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        title_pos = "center",
      },
      highlights = {
        Normal = {
          guibg = "#0d1117",
        },
        FloatBorder = {
          guifg = "#a7c080",
          guibg = "#0d1117",
        },
      },
    })

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  on_open = function(term)

    term.float_opts = {
      border = "curved",
      title = " LazyGit ",
      title_pos = "center",
    }

    vim.cmd("startinsert!")
  end,
})

    _G._LAZYGIT_TOGGLE = function()
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      if vim.v.shell_error ~= 0 then
        vim.notify("Not inside a git repository", vim.log.levels.WARN, { title = "LazyGit" })
        return
      end
      lazygit:toggle()
    end
  end,
}

