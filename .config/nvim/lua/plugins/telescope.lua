return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
    {
      -- 原生 FZF 排序，速度比默认快几十倍
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "%.lock",
          "dist/",
          "build/",
        },
      },

      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          sort_lastused = true,
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
          },
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        project = {
          base_dirs = {
            "~/.config/nvim",
          },
          hidden_files = true,
          theme = "dropdown",
          order_by = "asc",
          sync_with_nvim_tree = true,
        },
      },
    })

    -- 加载扩展
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "project")

    -- 快捷键
    local builtin = require("telescope.builtin")
    local map = function(key, fn, desc)
      vim.keymap.set("n", key, fn, { noremap = true, silent = true, desc = desc })
    end

    -- 文件 / 搜索
    map("<Leader>ff", builtin.find_files,  "Find files")
    map("<Leader>fg", builtin.live_grep,   "Live grep")
    map("<Leader>fb", builtin.buffers,     "Buffers")
    map("<Leader>fh", builtin.help_tags,   "Help tags")
    map("<Leader>fp", ":Telescope project<CR>", "Projects")

    -- 额外实用功能
    map("<Leader>fr", builtin.resume,      "Resume last search")
    map("<Leader>fo", builtin.oldfiles,    "Recent files")
    map("<Leader>fw", builtin.grep_string, "Grep word under cursor")
    map("<Leader>fd", builtin.diagnostics, "Diagnostics")
    map("<Leader>fs", builtin.git_status,  "Git status")
  end,
}
