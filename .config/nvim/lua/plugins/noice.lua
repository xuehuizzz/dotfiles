return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    --------------------
    -- Cmdline 命令行
    --------------------
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {},
      format = {
        cmdline     = { pattern = "^:",                                              icon = " ",  lang = "vim" },
        search_down = { kind = "search", pattern = "^/",                             icon = "  ", lang = "regex" },
        search_up   = { kind = "search", pattern = "^%?",                            icon = "  ", lang = "regex" },
        filter      = { pattern = "^:%s*!",                                          icon = " $",  lang = "bash" },
        lua         = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = " ",  lang = "lua" },
        help        = { pattern = "^:%s*he?l?p?%s+",                                 icon = " 󰋖" },
        input       = { view = "cmdline_input",                                      icon = " 󰥻 " },
      },
    },

    --------------------
    -- Messages 消息
    --------------------
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },

    --------------------
    -- Popupmenu 弹出菜单
    --------------------
    popupmenu = {
      enabled = true,
      backend = "nui",
      kind_icons = {},
    },

    --------------------
    -- Notify 通知
    --------------------
    notify = {
      enabled = true,
      view = "notify",
    },

    --------------------
    -- LSP 相关
    --------------------
    lsp = {
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30,
        view = "mini",
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
        silent = false,
        view = nil,
        opts = {},
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
        view = nil,
        opts = {},
      },
      message = {
        enabled = true,
        view = "notify",
        opts = {},
      },
      documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = {
            concealcursor = "n",
            conceallevel = 3,
          },
        },
      },
    },

    --------------------
    -- Presets 预设
    --------------------
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      lsp_doc_border = true,
    },

    --------------------
    -- Views 视图
    --------------------
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      mini = {
        win_options = {
          winblend = 0,
        },
      },
    },

    --------------------
    -- Routes 路由 (过滤噪音)
    --------------------
    routes = {
      -- 保存文件时隐藏 "written" 消息
      {
        filter = { event = "msg_show", kind = "", find = "written" },
        opts = { skip = true },
      },
      -- 隐藏 "No information available" (LSP hover 空内容)
      {
        filter = { event = "notify", find = "No information available" },
        opts = { skip = true },
      },
      -- 超长消息自动转 split
      {
        filter = { event = "msg_show", min_height = 20 },
        view = "messages",
      },
    },

    --------------------
    -- 性能
    --------------------
    throttle = 1000 / 30,
  },

  --------------------
  -- 快捷键
  --------------------
  keys = {
    { "<leader>sn",  "",                                                                          desc = "+Noice" },
    { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c",   desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end,                                 desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end,                              desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end,                                  desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end,                              desc = "Dismiss All" },
    {
      "<C-f>",
      function() if not require("noice.lsp").scroll(4) then return "<C-f>" end end,
      silent = true, expr = true, desc = "Scroll Forward",
      mode = { "i", "n", "s" },
    },
    {
      "<C-b>",
      function() if not require("noice.lsp").scroll(-4) then return "<C-b>" end end,
      silent = true, expr = true, desc = "Scroll Backward",
      mode = { "i", "n", "s" },
    },
  },
}
