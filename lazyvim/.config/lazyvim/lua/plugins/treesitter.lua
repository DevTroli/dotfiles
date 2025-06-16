-- Configuração robusta do nvim-treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    opts = function(_, opts)
      -- Linguagens essenciais para desenvolvimento moderno
      vim.list_extend(opts.ensure_installed, {
        -- Linguagens web fundamentais
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        -- Configuração e dados
        "json",
        "json5",
        "jsonc",
        "yaml",
        "toml",
        "xml",
        -- Linguagens de programação populares
        "python",
        "rust",
        "go",
        "java",
        "c",
        "cpp",
        -- Linguagens funcionais e modernas
        "lua",
        "bash",
        "fish",
        "zsh",
        -- Documentação e markup
        "markdown",
        "markdown_inline",
        "rst",
        -- Configuração de ferramentas
        "dockerfile",
        "gitignore",
        "gitcommit",
        -- Query languages e regex
        "query",
        "regex",
        "sql",
        -- Linguagens específicas para configuração
        "vim",
        "vimdoc",
        "comment",
      })
      -- Configurações adicionais que melhoram a experiência
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false -- Melhora performance
      opts.indent = opts.indent or {}
      opts.indent.enable = true
      -- Configuração para seleção incremental (muito útil)
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      }
      -- Configuração para text objects (navegar por código semanticamente)
      opts.textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automaticamente pula para o próximo textobj
          keymaps = {
            -- Você pode usar os capture groups definidos em textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      }
      return opts
    end,
    config = function(_, opts)
      -- Configuração personalizada se necessário
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- Plugin para mostrar contexto atual (útil em arquivos grandes)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
    },
    keys = {
      -- Keymap para ir para o contexto
      {
        "<leader>ut",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}
