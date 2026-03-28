return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "切换文件树" },
      { "<leader>fe", "<cmd>Neotree reveal<cr>", desc = "定位当前文件" },
    },

    opts = {
      close_if_last_window = true,

      -- ── 全局 UI ───────────────────────────────────────
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      enable_modified_markers = true,

      -- ── 不显示顶部 tab 栏 ────────────────────────────
      source_selector = {
        winbar = false,
        statusline = false,
      },

      -- ── 默认组件配置 ──────────────────────────────────
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "󰈚",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "●",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added     = "✚",
            modified  = "",
            deleted   = "✖",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
        diagnostics = {
          symbols = {
            hint  = "",
            info  = "",
            warn  = "",
            error = "",
          },
          highlights = {
            hint  = "DiagnosticSignHint",
            info  = "DiagnosticSignInfo",
            warn  = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
      },

      -- ── 文件系统源 ────────────────────────────────────
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        group_empty_dirs = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            "node_modules",
            "__pycache__",
            ".cache",
            ".DS_Store",
            "thumbs.db",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
        window = {
          mappings = {
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<C-x>"] = "clear_filter",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
        },
      },

      -- ── 窗口配置 ──────────────────────────────────────
      window = {
        position = "left",
        width = 34,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = false,
          ["<cr>"]    = "open",
          ["o"]       = "open",
          ["s"]       = "open_split",
          ["v"]       = "open_vsplit",
          ["t"]       = "open_tabnew",
          ["w"]       = "open_with_window_picker",
          ["C"]       = "close_node",
          ["z"]       = "close_all_nodes",
          ["Z"]       = "expand_all_nodes",
          ["a"]       = { "add", config = { show_path = "relative" } },
          ["d"]       = "delete",
          ["r"]       = "rename",
          ["y"]       = "copy_to_clipboard",
          ["x"]       = "cut_to_clipboard",
          ["p"]       = "paste_from_clipboard",
          ["c"]       = "copy",
          ["m"]       = "move",
          ["q"]       = "close_window",
          ["R"]       = "refresh",
          ["?"]       = "show_help",
        },
      },
    },

    config = function(_, opts)
      vim.opt.termguicolors = true

      require("neo-tree").setup(opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("NeoTreeAutoOpen", { clear = true }),
        callback = function()
          local arg = vim.fn.argv(0)
          if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
            vim.defer_fn(function()
              vim.cmd("Neotree show")
            end, 0)
          end
        end,
      })

      local function set_hl()
        local hl = vim.api.nvim_set_hl
        hl(0, "NeoTreeDirectoryName", { bold = true })
        hl(0, "NeoTreeDirectoryIcon", { fg = "#7aa2f7" })
        hl(0, "NeoTreeRootName", { bold = true, italic = true, fg = "#bb9af7" })
        hl(0, "NeoTreeGitAdded", { fg = "#9ece6a" })
        hl(0, "NeoTreeGitModified", { fg = "#e0af68" })
        hl(0, "NeoTreeGitDeleted", { fg = "#f7768e" })
        hl(0, "NeoTreeGitUntracked", { fg = "#73daca" })
        hl(0, "NeoTreeModified", { fg = "#e0af68" })
      end

      set_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("NeoTreeHL", { clear = true }),
        callback = set_hl,
      })
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },
}
