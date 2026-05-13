local exclude = {
  ".git",
  "node_modules",
  "__pycache__",
  ".venv",
  ".ruff_cache",
  ".mypy_cache",
  ".pytest_cache",
  ".DS_Store",
  "dist",
  "build",
  ".next",
  ".cache",
}

return {
  "folke/snacks.nvim",

  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {

    -- ══════════════════════════════════════════
    -- Dashboard
    -- ══════════════════════════════════════════
    dashboard = {
      enabled = vim.fn.argc() == 0,

      width = 60,

      preset = {
        header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]],

        keys = {
          { key = "f", desc = "Find File",    action = ":lua Snacks.picker.files()" },
          { key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { key = "g", desc = "Live Grep",    action = ":lua Snacks.picker.grep()" },
          { key = "p", desc = "Projects",     action = ":lua Snacks.picker.projects()" },
          { key = "c", desc = "Config",       action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { key = "l", desc = "Lazy",         action = ":Lazy" },
          { key = "h", desc = "Health",       action = ":checkhealth" },
          { key = "q", desc = "Quit",         action = ":qa" },
        },
      },

      sections = {
        { section = "header", padding = 1 },

        {
          align = "center",
          text = {
            { "┄┄┄┄┄┄┄┄━━━━━━━━━━━━━━━━━━━━┄┄┄┄┄┄┄┄", hl = "Comment" },
          },
        },

        {
          align = "center",
          padding = 1,
          text = {
            { "Code",    hl = "Function" },
            { "  ◆  ",   hl = "Comment" },
            { "Create",  hl = "String" },
            { "  ◆  ",   hl = "Comment" },
            { "Conquer", hl = "Keyword" },
          },
        },

        {
          align = "center",
          text = {
            { "┄┄┄┄┄┄┄┄━━━━━━━━━━━━━━━━━━━━┄┄┄┄┄┄┄┄", hl = "Comment" },
          },
        },

        { section = "keys", gap = 1, padding = 2 },
        { section = "startup" },
      },
    },

    -- ══════════════════════════════════════════
    -- Picker
    -- ══════════════════════════════════════════
    picker = {
      enabled = true,

      sources = {
        files = {
          hidden = true,
          exclude = exclude,
        },

        grep = {
          hidden = true,
          exclude = exclude,
        },

        explorer = {
          hidden = true,
          follow_file = true,
          exclude = exclude,

          layout = {
            preset = "sidebar",
            preview = false,

            layout = {
              width = 0.22,
            },
          },
        },
      },

      matcher = {
        smartcase = true,
        ignorecase = true,
      },

      layout = {
        preset = "ivy",

        layout = {
          height = 0.35,
        },
      },

      win = {
        input = {
          border = "rounded",

          keys = {
            ["<Esc>"] = { "close",     mode = { "n", "i" } },
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up",   mode = { "i", "n" } },
            ["<C-q>"] = { "qflist",    mode = { "i", "n" } },
          },
        },

        list = {
          border = "rounded",
        },

        preview = {
          border = "rounded",
        },
      },
    },

    -- ══════════════════════════════════════════
    -- Explorer
    -- ══════════════════════════════════════════
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    notifier = {
      enabled  = true,
      top_down = false,
      style    = "compact",

      -- timeout 必须是数字(毫秒),不能是 function
      timeout  = 4000,

      -- 不同 level 的 icon(可选)
      icons = {
        error = " ",
        warn  = " ",
        info  = " ",
        debug = " ",
        trace = " ",
      },
    },

    -- ══════════════════════════════════════════
    -- Indent
    -- ══════════════════════════════════════════
    indent = {
      enabled = true,

      animate = {
        enabled = false,
      },

      indent = {
        char = "│",
      },

      scope = {
        enabled = true,
        char = "│",
      },
    },

    -- ══════════════════════════════════════════
    -- Terminal
    -- ══════════════════════════════════════════
    terminal = {
      enabled = true,

      win = {
        style  = "float",
        border = "rounded",

        width  = 0.88,
        height = 0.85,

        wo = {
          winblend = 10,
        },
      },
    },

    -- ══════════════════════════════════════════
    -- Zen Mode
    -- ══════════════════════════════════════════
    zen = {
      enabled = true,
    },

    -- ══════════════════════════════════════════
    -- Utility Modules
    -- ══════════════════════════════════════════
    bigfile      = { enabled = true },
    quickfile    = { enabled = true },
    words        = { enabled = true },
    scroll       = { enabled = true },
    input        = { enabled = true },
    scope        = { enabled = true },
    rename       = { enabled = true },
    statuscolumn = { enabled = true },
    bufdelete    = { enabled = true },
  },

  -- ══════════════════════════════════════════
  -- Keymaps
  -- ══════════════════════════════════════════
  keys = {

    -- Picker
    { "<leader>ff", function() Snacks.picker.files() end,      desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end,       desc = "Live Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,  desc = "Grep Word" },
    { "<leader>fb", function() Snacks.picker.buffers() end,    desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end,       desc = "Help Tags" },
    { "<leader>fr", function() Snacks.picker.resume() end,     desc = "Resume" },
    { "<leader>fo", function() Snacks.picker.recent() end,     desc = "Recent Files" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end,desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>fp", function() Snacks.picker.projects() end,   desc = "Projects" },

    -- Explorer
    { "<leader>e",  function() Snacks.explorer.toggle() end,                       desc = "Explorer" },
    { "<leader>fe", function() Snacks.explorer.open({ follow_file = true }) end,   desc = "Reveal File" },

    -- Terminal
    { "<leader>t",  function() Snacks.terminal.toggle() end, mode = { "n", "t" },  desc = "Terminal" },

    -- Buffer
    { "<leader>bd", function() Snacks.bufdelete() end,       desc = "Delete Buffer" },

    -- UI
    { "<leader>un", function() Snacks.notifier.hide() end,   desc = "Dismiss Notifications" },
    { "<leader>z",  function() Snacks.zen() end,             desc = "Zen Mode" },

    -- References
    { "]]", function() Snacks.words.jump(vim.v.count1) end,  mode = "n", desc = "Next Reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, mode = "n", desc = "Prev Reference" },
  },

  -- ══════════════════════════════════════════
  -- Init
  -- ══════════════════════════════════════════
  init = function()

    -- Dashboard: 禁用一些 UI 元素 + 屏蔽滚轮
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_dashboard",
      callback = function(ev)
        local buf = ev.buf
        local win = vim.fn.bufwinid(buf)

        if win ~= -1 then
          vim.wo[win].cursorline     = false
          vim.wo[win].number         = false
          vim.wo[win].relativenumber = false
          vim.wo[win].signcolumn     = "no"
          vim.opt_local.scrolloff    = 10
        end

        for _, key in ipairs({ "<ScrollWheelUp>", "<ScrollWheelDown>" }) do
          vim.keymap.set("n", key, "<Nop>", {
            buffer = buf,
            silent = true,
          })
        end
      end,
    })

    -- Indent 高亮
    local function set_indent_hl()
      vim.api.nvim_set_hl(0, "SnacksIndent",      { link = "Comment" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Special" })
    end

    set_indent_hl()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_indent_hl,
    })

    -- 若需要对 ERROR 级别通知使用更长的显示时间,
    -- 改用全局覆盖 vim.notify(而不是在 snacks 配置里传 function)
    local orig_notify = vim.notify
    vim.notify = function(msg, level, opts)
      opts = opts or {}
      if level == vim.log.levels.ERROR and not opts.timeout then
        opts.timeout = 8000
      end
      return orig_notify(msg, level, opts)
    end
  end,
}
