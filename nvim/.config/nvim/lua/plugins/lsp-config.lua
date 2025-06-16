return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason LSP integration
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "pyright",
        "solargraph",
        "rust_analyzer",
        "marksman",
      },
      automatic_installation = true,
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local telescope = require("telescope.builtin")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps globais
      local function setup_keymaps(bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- Telescope LSP
        map("n", "gd", telescope.lsp_definitions, "Go to Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
        map("n", "gi", telescope.lsp_implementations, "Go to Implementation")
        map("n", "gr", telescope.lsp_references, "Go to References")
        map("n", "gt", telescope.lsp_type_definitions, "Go to Type Definition")

        -- Actions
        map({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>r", vim.lsp.buf.rename, "Rename")
        map({ "n", "v" }, "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format")

        -- Diagnostics
        map("n", "<leader>d", telescope.diagnostics, "Workspace Diagnostics")
        map("n", "<leader>D", function()
          telescope.diagnostics({ bufnr = 0 })
        end, "Buffer Diagnostics")
        map("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "Next Diagnostic")
        map("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "Prev Diagnostic")
        map("n", "<leader>'", vim.diagnostic.open_float, "Show Diagnostic")
      end

      local default_setup = {
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          setup_keymaps(bufnr)
        end,
      }

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        ts_ls = {},

        html = {
          filetypes = { "html", "htmldjango" },
        },

        cssls = {},

        tailwindcss = {
          filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        },

        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
              },
            },
          },
        },

        solargraph = {
          settings = {
            solargraph = {
              diagnostics = true,
              completion = true,
            },
          },
        },

        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },

        marksman = {},
      }

      -- Setup dos servidores
      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", default_setup, config))
      end

      -- Configuração de diagnósticos
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = "always",
          border = "rounded",
        },
      })

      -- Ícones de diagnóstico (API moderna)
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })
    end,
  },
}
