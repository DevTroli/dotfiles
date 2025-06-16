return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    require("notify").setup({
      background_colour = "#0d1117",
      timeout = 3000,
      top_down = true,
      stages = "fade_in_slide_out",
      render = "wrapped-compact",
      level = vim.log.levels.INFO,
      icons = {
        ERROR = "✘",
        WARN = "▲",
        INFO = "●",
        DEBUG = "◆",
        TRACE = "✎",
      },
    })

    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = "$ ", title = " Command " },
          search_down = { kind = "search", pattern = "^/", icon = "  ", title = "Buscar ↓" },
          search_up = { kind = "search", pattern = "^%?", icon = "  ", title = "Buscar ↑" },
          filter = { pattern = "^:%s*!", icon = "⌘", title = " Shell " },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "◐", title = " Lua " },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "❓", title = " Help " },
        },
      },

      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
      },

      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {
          Class = "◉", Color = "◈", Constant = "◇", Constructor = "⚒", Enum = "◎",
          EnumMember = "◦", Event = "⚡", Field = "◆", File = "⬜", Folder = "⬛",
          Function = "ƒ", Interface = "◐", Keyword = "◉", Method = "ƒ", Module = "◫",
          Operator = "⚬", Property = "◆", Reference = "⬟", Snippet = "◊", Struct = "◎",
          Text = "◯", TypeParameter = "◈", Unit = "◦", Value = "◇", Variable = "◌",
        },
      },

      lsp = {
        hover = { enabled = true },
        signature = { enabled = true, auto_open = { enabled = true } },
        progress = { enabled = true, view = "mini" },
      },

      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },

      views = {
        cmdline_popup = {
          position = { row = 5, col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded", padding = { 1, 2 } },
        },
        popup = {
          position = "50%",
          size = { width = "80%", height = "60%" },
          border = { style = "rounded" },
        },
        mini = {
          position = { row = -2, col = "100%" },
          timeout = 3000,
        },
      },

      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
            },
          },
          view = "mini",
        },
        {
          filter = { event = "msg_show", kind = { "emsg", "wmsg" } },
          view = "notify",
        },
      },
    })

    if pcall(require, "telescope") then
      require("telescope").load_extension("noice")
    end

    -- Keymaps simplificados
    local map = vim.keymap.set
    map("n", "<leader>nh", "<cmd>Noice history<cr>", { desc = "Histórico de mensagens" })
    map("n", "<leader>nl", "<cmd>Noice last<cr>", { desc = "Última mensagem" })
    map("n", "<leader>ne", "<cmd>Noice errors<cr>", { desc = "Erros" })
    map("n", "<leader>nd", "<cmd>Noice disable<cr>", { desc = "Desabilitar Noice" })
    map("n", "<leader>nn", "<cmd>Noice enable<cr>", { desc = "Habilitar Noice" })
    if pcall(require, "telescope") then
      map("n", "<leader>nt", "<cmd>Telescope noice<cr>", { desc = "Telescope Noice" })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("NoiceColors", { clear = true }),
      callback = function()
        local colors = {
          surface = "#21262d",
          green = "#a7c080",
          sky = "#87c095",
          fg = "#e6edf3",
        }

        vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = colors.surface, fg = colors.fg })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = colors.green })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = colors.green })
        vim.api.nvim_set_hl(0, "NoicePopupBorder", { fg = colors.sky })
      end,
    })
  end,
}
