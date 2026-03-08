return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "jay-babu/mason-nvim-dap.nvim",
    "rcarriga/nvim-dap-ui",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb" }, -- Adicione outros adaptadores aqui (ex: 'java-debug-adapter')
      handlers = {}, -- Deixe vazio para usar as configurações padrão do mason-dap
    })

    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1 },
          },
          size = 0.25,
          position = "bottom",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- C/C++
    dap.configurations.cpp = {
      {
        name = "Launch (C++)",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- Java (Exemplo para o futuro, como você pediu)
    -- Para isso funcionar, você adicionaria 'java-debug-adapter' no ensure_installed do mason-nvim-dap
    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Launch (Java)',
        mainClass = '', -- Geralmente detectado automaticamente
      },
    }
    -- Adicione outras linguagens aqui...
  end,
}

