local M = {}

local colors = {
  base = "#0d1117",
  mantle = "#161b22", 
  crust = "#21262d",
  
  surface1_enhanced = "#2d3748",
  
  -- Text hierarchy
  text = "#e6edf3",
  subtext1 = "#b1bac4",
  subtext0 = "#8b949e",
  
  -- Surface layers
  surface2 = "#30363d",
  surface1 = "#21262d", 
  surface0 = "#161b22",
  
  -- Overlay neutrals
  overlay2 = "#6e7681",
  overlay1 = "#7d8590",
  overlay0 = "#656d76",
  
  -- Core green palette
  green = "#a7c080",    
  green_bright = "#b8d4a3", 
  green_dark = "#7a9c6d",
  sky = "#87c095",
  teal = "#95c4ce",
  
  -- Supporting colors
  blue = "#4fb3d9",
  yellow = "#d7ba7d",
  red = "#e67e80",
  peach = "#e78a4e",
  sapphire = "#56b6c2",
  lavender = "#7c8bb8",
  mauve = "#d699b6",
  pink = "#ff7eb6",
  flamingo = "#ee8695",
  rosewater = "#f2d5cf",
  maroon = "#ea999c",
}

-- Plugin integrations
local integrations = {
  cmp = true,
  gitsigns = true,
  treesitter = true,
  lsp_trouble = true,
  which_key = true,
  bufferline = true,
  symbols_outline = true,
  notify = true,
  neotree = false,
  telescope = {
    enabled = true,
    style = "nvchad"
  },
  indent_blankline = {
    enabled = true,
    colored_indent_levels = true,
  },
}

-- Syntax highlighting styles
local styles = {
  comments = { "italic" },
  conditionals = { "bold" },
  loops = { "bold" },
  keywords = { "bold" },
  booleans = { "bold" },
  types = { "bold" },
  functions = {},
  strings = {},
  variables = {},
  numbers = {},
  properties = {},
  operators = {},
}

-- Custom highlights for terminal green theme
local function get_highlights(c)
  return {
    -- Cursor and selection - High contrast green variants
    Cursor = { bg = c.green_bright, fg = c.base, style = { "bold" } },
    CursorLine = { bg = c.surface1_enhanced }, -- Enhanced contrast background
    CursorColumn = { bg = c.surface1_enhanced },
    Visual = { bg = c.green_dark, fg = c.text, style = { "bold" } }, -- Dark green with white text
    VisualNOS = { bg = c.green_dark, fg = c.text }, -- Non-owned selection
    
    -- Line numbers - Enhanced contrast
    LineNr = { fg = c.overlay1 },
    CursorLineNr = { fg = c.green_bright, style = { "bold" } }, -- Brighter green
    
    -- Syntax elements
    Comment = { fg = c.overlay2, style = { "italic" } },
    Keyword = { fg = c.green, style = { "bold" } },
    Function = { fg = c.blue },
    String = { fg = c.sky },
    Identifier = { fg = c.text },
    Constant = { fg = c.teal },
    Operator = { fg = c.subtext1 },
    Type = { fg = c.sapphire, style = { "bold" } },
    
    -- Diagnostics
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.teal },
    
    -- Git signs
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
    
    -- Neo-tree
    NeoTreeDirectoryIcon = { fg = c.green },
    NeoTreeDirectoryName = { fg = c.blue },
    NeoTreeFileName = { fg = c.text },
    NeoTreeFileIcon = { fg = c.subtext1 },
    NeoTreeModified = { fg = c.yellow },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitModified = { fg = c.yellow },
    NeoTreeGitDeleted = { fg = c.red },
    
    -- Telescope
    TelescopePromptBorder = { fg = c.green },
    TelescopeSelectionCaret = { fg = c.green },
    TelescopeSelection = { bg = c.surface1 },
  }
end

-- Apply post-theme configurations
local function post_setup()
  vim.opt.cursorline = true
  vim.opt.termguicolors = true
  vim.opt.background = "dark"
  
  -- Optional: Uncomment for transparent background
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
end

-- Main configuration
function M.setup()
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    show_end_of_buffer = true,
    term_colors = true,
    
    color_overrides = {
      mocha = colors
    },
    
    integrations = integrations,
    styles = styles,
    custom_highlights = get_highlights,
    
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
  })
  
  vim.cmd.colorscheme("catppuccin")
  post_setup()
end

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = M.setup
  }
}
