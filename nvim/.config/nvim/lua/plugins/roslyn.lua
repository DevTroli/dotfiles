local M = {}

return {
  {
    "seblyng/roslyn.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("roslyn").setup({
        config = {
          handlers = {
            ["textDocument/definition"] = require("vim.lsp.handlers").definition,
          },
          on_attach = function(client, bufnr)
          end,
          capabilities = capabilities,
        },

        -- Só para arquivos .cs
        filetypes = { "cs" },
      })
    end,
  },
}
