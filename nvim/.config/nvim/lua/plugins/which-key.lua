return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      preset = "modern",
      delay = 500,
      expand = 1,
      notify = true,
      triggers = {
        { "<leader>", mode = { "n", "v" } },
      },
      icons = {
        breadcrumb = "»",
        separator = "→",
        mappings = true,
      },
      win = {
        border = "single",
        padding = { 1, 2 },
      },
      -- Filtrar mapeamentos desabilitados
      filter = function(mapping)
        return mapping.desc ~= "disabled"
      end,
      -- Adicionar estas opções para controlar melhor os mapeamentos
      plugins = {
        marks = false,
        registers = false,
        spelling = {
          enabled = false,
        },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
      -- Desabilitar detecção automática se necessário
      spec = {},
    })

    -- Registrar mapeamentos
    wk.add({
      ----------------------------------------------------------------
      -- LEADER MAPPINGS
      ----------------------------------------------------------------
      { "<leader>b", group = "Buffers" },
      { "<leader>bd", "<cmd>bd<cr>", desc = "Delete" },
      { "<leader>bn", "<cmd>bnext<cr>", desc = "Next" },
      { "<leader>bp", "<cmd>bprev<cr>", desc = "Prev" },
      { "<leader>bx", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Others" },
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick & Close" },
      { "<leader>bs", "<cmd>BufferLineCycleNext<cr>", desc = "Cycle Next" },
      { "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", desc = "Cycle Prev" },


      { "<leader>f", group = "Find" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todos" },

      { "<leader>g", group = "Git" },
      { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "LazyGit" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line" },

      { "<leader>h", group = "Help" },
      { "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" },

      { "<leader>l", group = "LSP" },
      { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
      { "<leader>ld", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to Declaration" },
      { "<leader>lg", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to Definition" },
      { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to Implementation" },
      { "<leader>lR", "<cmd>Telescope lsp_references<cr>", desc = "Go to References" },
      { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Go to TypeDef" },

      { "<leader>m", group = "MISE" },
      { "<leader>mm", "<cmd>terminal mise<cr>", desc = "MISE Terminal" },
      { "<leader>ml", "<cmd>terminal mise list<cr>", desc = "List Tools" },
      { "<leader>mi", "<cmd>terminal mise install<cr>", desc = "Install Tool" },
      { "<leader>mu", "<cmd>terminal mise use<cr>", desc = "Use Tool" },
      { "<leader>ms", "<cmd>terminal mise status<cr>", desc = "Status" },

      { "<leader>n", group = "Noice" },
      { "<leader>nn", "<cmd>Noice enable<cr>", desc = "Enable" },
      { "<leader>nd", "<cmd>Noice disable<cr>", desc = "Disable" },
      { "<leader>ne", "<cmd>Noice errors<cr>", desc = "Errors" },
      { "<leader>nl", "<cmd>Noice last<cr>", desc = "Last" },
      { "<leader>nh", "<cmd>Noice history<cr>", desc = "History" },
      { "<leader>nt", "<cmd>Telescope noice<cr>", desc = "Telescope" },

      { "<leader>s", group = "Toggle" },
      { "<leader>sn", "<cmd>set number!<cr>", desc = "Line Numbers" },
      { "<leader>sr", "<cmd>set relativenumber!<cr>", desc = "Relative Numbers" },
      { "<leader>sw", "<cmd>set wrap!<cr>", desc = "Word Wrap" },

      { "<leader>x", group = "Trouble" },
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Workspace Diag" },
      { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", desc = "Document Diag" },
      { "<leader>xr", "<cmd>Trouble lsp_references<cr>", desc = "References" },

      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
      { "<leader>w", "<cmd>write<cr>", desc = "Save" },
      { "<leader>q", "<cmd>quit<cr>", desc = "Quit" },

      ----------------------------------------------------------------
      -- NAVIGATION MAPPINGS (sem leader)
      ----------------------------------------------------------------
      { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diag" },
      { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },

      { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diag" },
      { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },

      ----------------------------------------------------------------
      -- FOLDING MAPPINGS
      ----------------------------------------------------------------
      { "zc", "zc", desc = "Close Fold" },
      { "zo", "zo", desc = "Open Fold" },
      { "zm", "zm", desc = "Close All More" },
      { "zM", "zM", desc = "Close All" },

      -- Adicionar no final do wk.add({})
      { "<leader>1", "<nop>", desc = "disabled" },
      { "<leader>2", "<nop>", desc = "disabled" },
      { "<leader>3", "<nop>", desc = "disabled" },
      { "<leader>4", "<nop>", desc = "disabled" },
      { "<leader>5", "<nop>", desc = "disabled" },
      { "<leader>6", "<nop>", desc = "disabled" },
      { "<leader>7", "<nop>", desc = "disabled" },
      { "<leader>8", "<nop>", desc = "disabled" },
      { "<leader>9", "<nop>", desc = "disabled" },
    })
  end,
}
