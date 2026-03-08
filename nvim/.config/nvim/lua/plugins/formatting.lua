return {
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          cs = { "csharpier" },
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
  },
}
