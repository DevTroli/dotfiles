return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local hlchunk = require("hlchunk")
    
    -- Configuração local que será reutilizada
    local config = {
      chunk = {
        enable = true,
        priority = 15,
        style = {
          { fg = "#a7c080" },
          { fg = "#e67e80" },
        },
        use_treesitter = true,
        chars = {
          horizontal_line = "─",
          vertical_line = "│", 
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        textobject = "",
        max_file_size = 1024 * 1024,
        error_sign = true,
        support_filetypes = {
          "*.ts", "*.js", "*.lua", "*.py", "*.go", "*.rs", "*.c", "*.cpp"
        },
      },
      indent = {
        enable = true,
        priority = 10,
        style = {
          { fg = "#30363d" },
          { fg = "#21262d" },
        },
        use_treesitter = false,
        chars = { "│", "¦", "┆", "┊" },
        ahead_lines = 5,
        delay = 100,
      },
      line_num = {
        enable = true,
        priority = 10,
        style = "#87c095",
        use_treesitter = true,
      },
      blank = {
        enable = false,
        priority = 9,
        style = {
          { bg = "#161b22" },
        },
        chars = { " " },
      },
    }

    -- Inicializa o plugin com a configuração
    hlchunk.setup(config)

    -- Funções de toggle usando a cópia local da configuração
    local function toggle_chunk()
      config.chunk.enable = not config.chunk.enable
      hlchunk.setup(config)
      vim.notify("Chunk highlighting " .. (config.chunk.enable and "enabled" or "disabled"), vim.log.levels.INFO)
    end

    local function toggle_indent()
      config.indent.enable = not config.indent.enable
      hlchunk.setup(config)
      vim.notify("Indent guides " .. (config.indent.enable and "enabled" or "disabled"), vim.log.levels.INFO)
    end

    -- Keymaps atualizados
    vim.keymap.set("n", "<leader>tc", toggle_chunk, { desc = "Toggle chunk highlighting" })
    vim.keymap.set("n", "<leader>ti", toggle_indent, { desc = "Toggle indent guides" })

    -- Grupo de autocomandos
    local augroup = vim.api.nvim_create_augroup("HLChunkOptimization", { clear = true })
    
    -- Desabilita em arquivos muito grandes
    vim.api.nvim_create_autocmd("BufReadPre", {
      group = augroup,
      callback = function()
        local file_size = vim.fn.getfsize(vim.fn.expand("%"))
        if file_size > config.chunk.max_file_size then
          config.chunk.enable = false
          config.indent.enable = false
          hlchunk.setup(config)
        end
      end,
    })
    
    -- Desabilita em filetypes específicos
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = { 
        "dashboard", "alpha", "startify", "aerial", "nerdtree", "neo-tree",
        "Trouble", "lazy", "mason", "help", "checkhealth", "lspinfo",
        "TelescopePrompt", "TelescopeResults"
      },
      callback = function()
        config.chunk.enable = false
        config.indent.enable = false
        hlchunk.setup(config)
      end,
    })

    -- Integração com colorscheme
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = augroup,
      callback = function()
        -- Atualiza as cores para combinar com o novo esquema
        config.chunk.style = {
          { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Comment")), "fg") or "#a7c080" },
          { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Error")), "fg") or "#e67e80" },
        }
        config.indent.style = {
          { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("LineNr")), "fg") or "#30363d" },
          { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("CursorLineNr")), "fg") or "#21262d" },
        }
        config.line_num.style = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Number")), "fg") or "#87c095"
        
        hlchunk.setup(config)
      end,
    })
  end,
}
