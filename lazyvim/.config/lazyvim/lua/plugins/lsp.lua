-- Configuração do LSP e Mason para desenvolvimento robusto
return {
  -- Configuração do Mason (gerenciador de LSP servers, DAPs, linters, formatters)
  {
    "williamboman/mason.nvim",
    opts = {
      -- Ferramentas que serão instaladas automaticamente
      ensure_installed = {
        -- Language Servers (LSPs)
        "lua-language-server", -- Lua
        "typescript-language-server", -- TypeScript/JavaScript
        "html-lsp", -- HTML
        "css-lsp", -- CSS
        "json-lsp", -- JSON
        "pyright", -- Python
        "rust-analyzer", -- Rust (se usar)

        -- Formatters (ferramentas de formatação)
        "stylua", -- Lua formatter
        "prettier", -- JS/TS/HTML/CSS formatter
        "black", -- Python formatter
        "isort", -- Python import sorter

        -- Linters (ferramentas de análise estática)
        "eslint_d", -- JavaScript/TypeScript linter
        "flake8", -- Python linter
        "shellcheck", -- Shell script linter
        "shfmt", -- Shell script formatter
      },
      ui = {
        -- Configuração da interface do Mason
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded", -- Bordas arredondadas para janelas
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "html", "cssls", "jsonls", "pyright", "rust_analyzer" },
    },
  },

  -- Plugin para esquemas JSON - ADICIONADO PARA RESOLVER O ERRO
  {
    "b0o/schemastore.nvim",
    lazy = true, -- Carrega apenas quando necessário
  },

  -- Configuração avançada do nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim", -- Dependência explícita do schemastore
    },
    opts = {
      -- Configuração global para todos os LSP servers
      diagnostics = {
        underline = true,
        update_in_insert = false, -- Não atualiza diagnósticos enquanto digita
        virtual_text = {
          spacing = 4,
          source = "if_many", -- Mostra fonte do diagnóstico se houver múltiplas
          prefix = "●", -- Símbolo usado para virtual text
        },
        severity_sort = true, -- Ordena diagnósticos por severidade
      },

      -- Configuração de servidores LSP específicos
      servers = {
        -- Lua LSP com configurações otimizadas para Neovim
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false, -- Desabilita prompt sobre third-party
              },
              completion = {
                callSnippet = "Replace", -- Como completar function calls
              },
              diagnostics = {
                -- Reconhece 'vim' como global (para configuração do Neovim)
                globals = { "vim" },
              },
              hint = {
                enable = true, -- Habilita inlay hints
              },
            },
          },
        },

        -- TypeScript/JavaScript LSP
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal", -- Mostra nomes de parâmetros
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Python LSP
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", -- Analisa todo o workspace
              },
            },
          },
        },

        -- JSON LSP com schema support - CONFIGURAÇÃO SEGURA
        jsonls = {
          on_new_config = function(new_config)
            -- Só tenta carregar o schemastore se ele estiver disponível
            local has_schemastore, schemastore = pcall(require, "schemastore")
            if has_schemastore then
              new_config.settings.json.schemas = schemastore.json.schemas()
            end
          end,
          settings = {
            json = {
              -- Configuração básica que funciona mesmo sem schemastore
              validate = { enable = true },
              -- schemas será definido dinamicamente no on_new_config
            },
          },
        },

        -- HTML LSP
        html = {
          filetypes = { "html", "htmldjango" }, -- Inclui templates Django
        },

        -- CSS LSP
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                -- Configurações de linting CSS
                compatibleVendorPrefixes = "ignore",
                vendorPrefix = "warning",
                duplicateProperties = "warning",
              },
            },
          },
        },
      },

      -- Configuração de keymaps quando LSP está ativo
      setup = {
        -- Esta função é chamada para cada server LSP
        ["*"] = function(server, opts)
          -- Aqui você pode adicionar configurações globais para todos os servers
          -- Por exemplo, configurar keymaps específicos
        end,
      },
    },
  },

  -- Configuração para mostrar diagnósticos de forma mais elegante
  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true, -- Usa os mesmos ícones do vim.diagnostic
      auto_open = false, -- Não abre automaticamente
      auto_close = true, -- Fecha automaticamente quando não há problemas
      padding = true, -- Adiciona padding
      indent_lines = true, -- Mostra linhas de indentação
      win_config = { border = "rounded" }, -- Bordas arredondadas
    },
    keys = {
      -- Keymaps para navegar problemas no código
      {
        "<leader>xx",
        "<cmd>TroubleToggle<cr>",
        desc = "Toggle Trouble",
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>xd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics",
      },
    },
  },
}
