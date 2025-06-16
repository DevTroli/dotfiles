return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  
  config = function()
    require("todo-comments").setup({
      signs = true,
      sign_priority = 8,
      
      keywords = {
        FIX = {
          icon = "×", -- Símbolo de erro/falha
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { 
          icon = "○", -- Círculo vazio indica pendência
          color = "info" 
        },
        HACK = { 
          icon = "!", -- Exclamação para gambiarra
          color = "warning" 
        },
        WARN = { 
          icon = "▲", -- Triângulo de warning padrão
          color = "warning", 
          alt = { "WARNING", "XXX" } 
        },
        PERF = { 
          icon = "↑", -- Seta para cima indica otimização
          alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } 
        },
        NOTE = { 
          icon = "※", -- Símbolo de referência/nota
          color = "hint", 
          alt = { "INFO" } 
        },
        TEST = { 
          icon = "✓", -- Checkmark para testes
          color = "test", 
          alt = { "TESTING", "PASSED", "FAILED" } 
        },
      },
      
      gui_style = {
        fg = "NONE",
        bg = "BOLD",
      },
      
      merge_keywords = true,
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
        max_line_len = 400,
        exclude = {},
      },
      
      colors = {
        error = { "#f38ba8", "DiagnosticError" },
        warning = { "#fab387", "DiagnosticWarn" },  
        info = { "#89b4fa", "DiagnosticInfo" },
        hint = { "#a6e3a1", "DiagnosticHint" },
        default = { "#cba6f7", "Identifier" },
        test = { "#f5c2e7", "Identifier" }
      },
      
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        pattern = [[\b(KEYWORDS):]], 
      },
    })
    
    -- Keymaps essenciais
    local map = vim.keymap.set
    
    map("n", "]t", function()
      require("todo-comments").jump_next()
    end, { desc = "Next todo comment" })
    
    map("n", "[t", function()
      require("todo-comments").jump_prev()
    end, { desc = "Previous todo comment" })
    
    map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    map("n", "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Find todos/fix/fixme" })
  end,
}

