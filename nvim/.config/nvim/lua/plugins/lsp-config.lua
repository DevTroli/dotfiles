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

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
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
        "clangd",
			},
			automatic_installation = true,
		},
	},

	-- LSP configuration (API nova)
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
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

			-- Definição dos servidores (sem usar lspconfig[server])
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
					filetypes = { "lua" },
				},

				ts_ls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				},

				html = {
					filetypes = { "html", "htmldjango" },
				},

				cssls = {
					filetypes = { "css", "scss", "less" },
				},

				tailwindcss = {
					filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
				},

				pyright = {
					filetypes = { "python" },
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
					filetypes = { "ruby" },
					settings = {
						solargraph = {
							diagnostics = true,
							completion = true,
						},
					},
				},

				rust_analyzer = {
					filetypes = { "rust" },
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = { command = "clippy" },
						},
					},
				},

				marksman = {
					filetypes = { "markdown" },
				},

        clangd = {
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
      },
    },
			}


      -- Registrar configs na API nova
			for server, config in pairs(servers) do
				local merged = vim.tbl_deep_extend("force", default_setup, config or {})
				-- dependendo da versão, use vim.lsp.config ou vim.lsp._config
				vim.lsp.config[server] = merged

				-- Auto-start por filetype
				if merged.filetypes then
					vim.api.nvim_create_autocmd("FileType", {
						pattern = merged.filetypes,
						callback = function(args)
							vim.lsp.start({
								name = server,
								bufnr = args.buf,
								cmd = merged.cmd or nil, -- se o server precisar de cmd manual
								root_dir = merged.root_dir and merged.root_dir(vim.api.nvim_buf_get_name(args.buf))
									or vim.loop.cwd(),
								capabilities = merged.capabilities,
								on_attach = merged.on_attach,
								settings = merged.settings,
							})
						end,
					})
				end
			end

			-- Configuração de diagnósticos (isso já está na API nova)
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
