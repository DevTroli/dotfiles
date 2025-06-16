return {
  -- 🎨 BUFFERLINE
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "ordinal",
          
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = "bdelete! %d",
          
          indicator = { icon = "▎", style = "icon" },
          buffer_close_icon = "×",
          modified_icon = "●",
          close_icon = "×",
          
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          
          max_name_length = 20,
          tab_size = 18,
          
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, level)
            return level:match("error") and " " or " "
          end,
          
          custom_filter = function(buf_number)
            local buf_ft = vim.fn.getbufvar(buf_number, "&filetype")
            local ignore = { "help", "alpha", "neo-tree", "Trouble", "toggleterm" }
            for _, ft in ipairs(ignore) do
              if buf_ft == ft then return false end
            end
            return true
          end,
          
          sort_by = "insert_after_current",
        },
      })
      
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      
      -- Navegação
      map('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', opts)
      map('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', opts)
      
      -- Fechar buffers
      map('n', '<leader>x', '<Cmd>bdelete<CR>', opts)
      map('n', '<leader>X', '<Cmd>bdelete!<CR>', opts)
      map('n', '<leader>bc', '<Cmd>BufferLinePickClose<CR>', opts)
      map('n', '<leader>bx', '<Cmd>BufferLineCloseOthers<CR>', opts)
      
      -- Movimentação de buffers
      map('n', '<A-,>', '<Cmd>BufferLineMovePrev<CR>', opts)
      map('n', '<A-.>', '<Cmd>BufferLineMoveNext<CR>', opts)
      
      -- Pick buffer
      map('n', '<leader>p', '<Cmd>BufferLinePick<CR>', opts)
      
      -- Navegação direta (Alt + número)
      for i = 1, 9 do
        map('n', '<A-' .. i .. '>', '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>', opts)
      end
    end,
  },

  -- 💾 PERSISTENCE SIMPLES
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize" },
      branch = true,
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restaurar sessão" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Última sessão" },
      { "<leader>qc", function() require("persistence").save() end, desc = "Salvar sessão" },
    },
  },

  -- 🏗️ SCOPE PARA TABS
  {
    "tiagovla/scope.nvim",
    config = function()
      require("scope").setup()
      
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      
      -- Tabs ergonômicos
      map('n', '<C-t>', '<Cmd>tabnew<CR>', opts)        -- Nova tab
      map('n', '<C-n>', '<Cmd>tabclose<CR>', opts)      -- Fechar tab
      map('n', 'tp', '<Cmd>tabprevious<CR>', opts)      -- Tab anterior
      map('n', 'tn', '<Cmd>tabnext<CR>', opts)          -- Próxima tab
      
      -- Navegação direta para tabs
      for i = 1, 9 do
        map('n', '<leader>' .. i, i .. 'gt', opts)
      end
    end,
  },
}
