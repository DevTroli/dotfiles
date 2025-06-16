-- Arquivo principal que importa todos os módulos de plugins
return {
  -- Se você quiser usar outros extras do LazyVim, descomente as linhas abaixo:
  -- { import = "lazyvim.plugins.extras.lang.python" },     -- Python com pyright, ruff, etc.
  -- { import = "lazyvim.plugins.extras.linting.eslint" },  -- ESLint integrado
  -- { import = "lazyvim.plugins.extras.formatting.prettier" }, -- Prettier integrado

  -- (plugins pequenos que não justificam um arquivo separado)

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {}, --your header
          center = {
            {
              icon = " ",
              icon_hl = "Title",
              desc = "Find File           ",
              desc_hl = "String",
              key = "b",
              keymap = "SPC f f",
              key_hl = "Number",
              key_format = " %s", -- remove default surrounding `[]`
              action = "lua print(2)",
            },
            {
              icon = " ",
              desc = "Find Dotfiles",
              key = "f",
              keymap = "SPC f d",
              key_format = " %s", -- remove default surrounding `[]`
              action = "lua print(3)",
            },
          },
          footer = {}, --your footer
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },

  -- Plugin para melhorar a experiência com comentários
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      -- Configuração básica para comentários inteligentes
      padding = true, -- Adiciona espaço após o marcador de comentário
      sticky = true, -- Cursor permanece na posição ao comentar
      ignore = "^$", -- Ignora linhas vazias
      toggler = {
        line = "gcc", -- Comentar linha atual
        block = "gbc", -- Comentar bloco
      },
      opleader = {
        line = "gc", -- Operador para comentar linhas
        block = "gb", -- Operador para comentar blocos
      },
    },
  },

  -- Plugin para melhorar a experiência com pares (parênteses, chaves, etc.)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- Usa treesitter para verificar contexto
      ts_config = {
        lua = { "string" }, -- Não adiciona pares em strings Lua
        javascript = { "template_string" }, -- Não adiciona em template strings
      },
      disable_filetype = { "TelescopePrompt" }, -- Desabilita em prompts do Telescope
      fast_wrap = {
        map = "<M-e>", -- Alt+e para wrap rápido
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
  },

  -- Plugin para mostrar cores inline (muito útil para CSS/web dev)
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        "*", -- Ativa para todos os tipos de arquivo
      }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes como Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() e rgba() functions
        hsl_fn = true, -- CSS hsl() e hsla() functions
        css = true, -- Habilita todas as features CSS
        css_fn = true, -- Habilita todas as CSS functions
      })
    end,
  },

  -- Plugin para melhorar a experiência com Git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    keys = {
      -- Keymaps úteis para Git
      {
        "<leader>gb",
        function()
          require("gitsigns").blame_line({ full = true })
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gd",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Git Diff This",
      },
      {
        "<leader>gp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Git Preview Hunk",
      },
    },
  },
}
