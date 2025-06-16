return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha     = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local banners   = require("banners")

    dashboard.config.layout[1].val = 2
    dashboard.config.layout[2].val = banners.dashboard()
    dashboard.config.layout[3].val = 2

    dashboard.section.buttons.val = {
      -- [n] New File (prompt de nome + extensão)
      dashboard.button("n", "  New File", ":lua NewFile()<CR>"),

      -- [g] LazyGit (sai do Neovim e executa o lazygit no próprio terminal)
      dashboard.button("g", "  Git", ":lua _LAZYGIT_TOGGLE()<CR>"),

      -- [f] Find Files (sem preview)
      dashboard.button("f", "  Find Files", ":Telescope find_files<CR>"),

      -- [c] Acessar configs do Neovim (na pasta ~/.config/nvim/)
      dashboard.button("c", "  Configs", ":cd ~/.config/nvim/ <CR>:Telescope find_files<CR>"),

     -- [q] Quit Neovim
      dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
    }

    _G.NewFile = function()
      vim.ui.input({ prompt = "File name: " }, function(input)
        if not (input and input ~= "") then
          return
        end
        local path = vim.fn.expand(input)
        local dir  = vim.fn.fnamemodify(path, ":h")
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, "p")
        end
        vim.cmd("edit " .. path)
      end)
    end

    vim.keymap.set("n", "<A-a>", "<cmd>Alpha<CR>", { desc = "Open Dashboard", noremap = true, silent = true })

    alpha.setup(dashboard.config)
  end,
}

