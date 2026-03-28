return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  keys = {
    {
      "<leader>un",
      function() require("notify").dismiss({ silent = true, pending = true }) end,
      desc = "Dismiss All Notifications",
    },
  },
  opts = {
    ---────────────────────────────────────
    -- 动画 & 渲染
    ---────────────────────────────────────
    stages = "fade_in_slide_out", -- 淡入 + 滑出
    render = "wrapped-compact",   -- 紧凑渲染，节省空间
    fps = 60,                     -- 动画帧率

    ---────────────────────────────────────
    -- 超时 & 尺寸
    ---────────────────────────────────────
    timeout = 3000,
    max_height = function() return math.floor(vim.o.lines * 0.75) end,
    max_width = function() return math.floor(vim.o.columns * 0.75) end,
    minimum_width = 50,

    ---────────────────────────────────────
    -- 位置 & 层级
    ---────────────────────────────────────
    top_down = false, -- 从右下角弹出

    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,

    ---────────────────────────────────────
    -- 图标
    ---────────────────────────────────────
    icons = {
      DEBUG = " ",
      ERROR = " ",
      INFO  = " ",
      TRACE = " ",
      WARN  = " ",
    },

    ---────────────────────────────────────
    -- 背景（如果你主题支持 NotifyBackground）
    ---────────────────────────────────────
    background_colour = "#000000",
  },

  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    -- 把 vim.notify 全局替换为 nvim-notify
    vim.notify = notify
  end,
}
