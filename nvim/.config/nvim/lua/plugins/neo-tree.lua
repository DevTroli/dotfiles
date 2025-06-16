return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    { "3rd/image.nvim", opts = {} },
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      close_if_last_window = false,
      popup_border_style = "NC",
      enable_git_status = false,
      enable_diagnostics = false,
      default_component_configs = {
        -- ... suas configs de componentes ...
        container = { enable_character_fade = true },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          -- ... sua função de icon ...
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        git_status = {
          -- ... seus simbolos git ...
        },
      },
      window = {
        position = "left",
        width = 40,
        mappings = {
          ["<tab>"] = "toggle_node",
          ["<cr>"] = "open",
          ["o"] = "open",
          ["go"] = { "open", config = { expand_nested_files = true } },
          ["u"] = "navigate_up",
          ["<bs>"] = "navigate_up",
          ["C"] = "set_root",
          ["."] = "set_root",
          ["i"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["I"] = "toggle_hidden",
          ["H"] = "toggle_hidden",
          ["R"] = "refresh",
          ["f"] = "filter_on_submit",
          ["F"] = "clear_filter",
          ["/"] = "fuzzy_finder",
          ["a"] = "add",
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["<leader>e"] = "close_window",
          ["?"] = "show_help",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["<esc>"] = "cancel",
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "node_modules", ".git", ".DS_Store" },
        },
        follow_current_file = { enabled = true, leave_dirs_open = true },
        use_libuv_file_watcher = true,
      },
      buffers = {
        follow_current_file = { enabled = false, leave_dirs_open = false },
      },
    })

    -- Este atalho global abre o Neo-tree
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
  end,
}
