-- Configuração do Telescope com integração FZF-Lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    keys = {
      -- Keymaps personalizados para o Telescope
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
      -- Adicione mais keymaps conforme sua necessidade
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find Help",
      },
    },
    opts = function(_, opts)
      -- Configurações do Telescope otimizadas
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          horizontal = {
            preview_width = 0.6,
            results_width = 0.4,
          },
        },
        sorting_strategy = "ascending",
        winblend = 0,
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        path_display = { "truncate" },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "*.pyc",
          "__pycache__",
          ".env",
          ".next",
        },
        -- Configurações de preview otimizadas
        preview = {
          treesitter = true,
        },
        -- Mapeamentos internos do Telescope
        mappings = {
          i = {
            ["<C-n>"] = require("telescope.actions").move_selection_next,
            ["<C-p>"] = require("telescope.actions").move_selection_previous,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      })

      -- Configurações específicas para pickers
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = {
        theme = "dropdown",
        previewer = false,
        hidden = true,
      }
      opts.pickers.live_grep = {
        theme = "ivy",
      }
      opts.pickers.buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
      }

      return opts
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      -- Carrega a extensão FZF se disponível
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}
