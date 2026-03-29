return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",

  opts = {
    options = {
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      mode = "buffers",
      themable = true,
      numbers = "none",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,

      -- 样式
      indicator = {
        icon = "▎",    -- 左侧指示条
        style = "icon", -- "icon" | "underline" | "none"
      },
      buffer_close_icon = "󰅖",
      modified_icon = "● ",
      close_icon = " ",
      left_trunc_marker = " ",
      right_trunc_marker = " ",

      -- 为 neo-tree 留出侧边栏偏移
      offsets = {
        {
          filetype = "snacks_layout_box",
          text = "  File Explorer",
          text_align = "left",
          highlight = "Directory",
          separator = true,
        },
      },

      -- 外观
      separator_style = "thin",   -- "slant" | "slope" | "thick" | "thin" | "padded_slant"
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      color_icons = true,

      -- 悬停事件（Neovim >= 0.8）
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },

      -- 诊断集成（配合你的 LSP）
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, _, _)
        local icon = level:match("error") and " "
          or (level:match("warning") and " " or " ")
        return " " .. icon .. count
      end,

      -- 自定义过滤：不在 bufferline 显示某些类型
      custom_filter = function(buf_number, _)
        local buf_ft = vim.bo[buf_number].filetype
        if buf_ft == "qf" or buf_ft == "fugitive" or buf_ft == "help" then
          return false
        end
        return true
      end,

      -- 排序方式
      sort_by = "insert_after_current",
    },

    -- 高亮定制（半透明风格，与大多数主题协调）
    highlights = {
      fill = {
        bg = { attribute = "bg", highlight = "Normal" },
      },
      background = {
        italic = true,
      },
      buffer_selected = {
        bold = true,
        italic = false,
      },
      diagnostic_selected = {
        bold = true,
      },
      error_selected = {
        bold = true,
        italic = false,
      },
      error_diagnostic_selected = {
        bold = true,
      },
      warning_selected = {
        bold = true,
        italic = false,
      },
      warning_diagnostic_selected = {
        bold = true,
      },
      info_selected = {
        bold = true,
        italic = false,
      },
      info_diagnostic_selected = {
        bold = true,
      },
      separator = {
        fg = { attribute = "bg", highlight = "Normal" },
      },
      separator_visible = {
        fg = { attribute = "bg", highlight = "Normal" },
      },
      separator_selected = {
        fg = { attribute = "bg", highlight = "Normal" },
      },
      indicator_selected = {
        fg = { attribute = "fg", highlight = "Function" },
      },
    },
  },

  -- 快捷键
  keys = {
    { "<S-h>",     "<cmd>BufferLineCyclePrev<CR>",            desc = "上一个 Buffer" },
    { "<S-l>",     "<cmd>BufferLineCycleNext<CR>",            desc = "下一个 Buffer" },
    { "<A-h>",     "<cmd>BufferLineMovePrev<CR>",             desc = "向左移动 Buffer" },
    { "<A-l>",     "<cmd>BufferLineMoveNext<CR>",             desc = "向右移动 Buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",           desc = "固定/取消固定 Buffer" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>",desc = "关闭未固定的 Buffer" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>",         desc = "关闭其他 Buffer" },
    { "<leader>bl", "<cmd>BufferLineCloseRight<CR>",          desc = "关闭右侧 Buffer" },
    { "<leader>bh", "<cmd>BufferLineCloseLeft<CR>",           desc = "关闭左侧 Buffer" },
    { "<leader>1",  "<cmd>BufferLineGoToBuffer 1<CR>",        desc = "跳转 Buffer 1" },
    { "<leader>2",  "<cmd>BufferLineGoToBuffer 2<CR>",        desc = "跳转 Buffer 2" },
    { "<leader>3",  "<cmd>BufferLineGoToBuffer 3<CR>",        desc = "跳转 Buffer 3" },
    { "<leader>4",  "<cmd>BufferLineGoToBuffer 4<CR>",        desc = "跳转 Buffer 4" },
    { "<leader>5",  "<cmd>BufferLineGoToBuffer 5<CR>",        desc = "跳转 Buffer 5" },
  },
}
