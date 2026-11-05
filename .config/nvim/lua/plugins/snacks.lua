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
          { icon = " ", key = "f", desc = "Find File",     action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "r", desc = "Recent Files",  action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "g", desc = "Grep Search",   action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "p", desc = "Projects",      action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "c", desc = "Config",        action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = "󰒲 ", key = "l", desc = "Lazy",          action = ":Lazy" },
          { icon = "󰓙 ", key = "h", desc = "Health",        action = ":checkhealth" },
          { icon = " ", key = "q", desc = "Quit",          action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 1 },
        {
          align = "center",
          padding = 1,
          text = {
            { "─  ", hl = "Comment" },
            { "Code", hl = "Function" },
            { "  ·  ", hl = "Comment" },
            { "Create", hl = "String" },
            { "  ·  ", hl = "Comment" },
            { "Conquer", hl = "Keyword" },
            { "  ─", hl = "Comment" },
          },
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    -- ══════════════════════════════════════════
    -- Picker
    -- ══════════════════════════════════════════
    picker = {
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
            layout = { width = 0.22 },
          },
          -- 解绑 <C-j>/<C-k>，让它们冒泡到全局，用于 toggle terminal
          win = {
            input = { keys = { ["<C-j>"] = false, ["<C-k>"] = false } },
            list  = { keys = { ["<C-j>"] = false, ["<C-k>"] = false } },
          },
        },
      },
      matcher = {
        smartcase = true,
        ignorecase = true,
      },
      layout = {
        preset = "ivy",
        layout = { height = 0.35 },
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
        list    = { border = "rounded" },
        preview = { border = "rounded" },
      },
    },
    -- ══════════════════════════════════════════
    -- Explorer
    -- ══════════════════════════════════════════
    explorer = {
      replace_netrw = true,
    },
    -- ══════════════════════════════════════════
    -- Notifier
    -- ══════════════════════════════════════════
    notifier = {
      top_down = false,
      style = "compact",
      timeout = 4000,
      icons = {
        error = " ",
        warn  = " ",
        info  = " ",
        debug = " ",
        trace = "✎ ",
      },
    },
    -- ══════════════════════════════════════════
    -- Indent
    -- ══════════════════════════════════════════
    indent = {
      animate = { enabled = false },
      indent = { char = "│" },
      scope  = {
        enabled = true,
        char = "│",
      },
    },
    -- ══════════════════════════════════════════
    -- Terminal
    -- ══════════════════════════════════════════
    terminal = {
      win = {
        style  = "float",
        border = "rounded",
        width  = 0.88,
        height = 0.85,
        wo = { winblend = 10 },
        keys = {
          term_hide = {
            "<C-j>",
            function(self) self:hide() end,
            mode = { "t", "n" },
            desc = "Hide Terminal",
          },
        },
      },
    },
    -- ══════════════════════════════════════════
    -- Zen + Utility
    -- ══════════════════════════════════════════
    zen          = { enabled = true },
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
    { "<leader>ff", function() Snacks.picker.files() end,       desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end,        desc = "Live Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,   desc = "Grep Word" },
    { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end,        desc = "Help Tags" },
    { "<leader>fr", function() Snacks.picker.resume() end,      desc = "Resume" },
    { "<leader>fo", function() Snacks.picker.recent() end,      desc = "Recent Files" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.git_status() end,  desc = "Git Status" },
    { "<leader>fp", function() Snacks.picker.projects() end,    desc = "Projects" },
    -- Explorer
    { "<leader>e",  function() Snacks.explorer.toggle() end,                     desc = "Explorer" },
    { "<leader>fe", function() Snacks.explorer.open({ follow_file = true }) end, desc = "Reveal File" },
    -- Terminal：统一用 <C-j> 开/关，覆盖 n/i/v/t
    {
      "<C-j>",
      function()
        local mode = vim.fn.mode()
        if mode ~= "n" and mode ~= "t" then
          vim.cmd("stopinsert")
        end
        Snacks.terminal.toggle()
      end,
      mode = { "n", "i", "v", "t" },
      desc = "Toggle Terminal",
    },
    -- Buffer / UI
    { "<leader>bd", function() Snacks.bufdelete() end,     desc = "Delete Buffer" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    { "<leader>z",  function() Snacks.zen() end,           desc = "Zen Mode" },
    -- Words
    { "]]", function() Snacks.words.jump(vim.v.count1) end,  mode = "n", desc = "Next Reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, mode = "n", desc = "Prev Reference" },
  },
  -- ══════════════════════════════════════════
  -- Init
  -- ══════════════════════════════════════════
  init = function()
    -- Dashboard：关掉多余 UI + 屏蔽滚轮
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
          vim.keymap.set("n", key, "<Nop>", { buffer = buf, silent = true })
        end
      end,
    })
    -- Indent 高亮（跟随 colorscheme）
    local function set_indent_hl()
      vim.api.nvim_set_hl(0, "SnacksIndent",      { link = "Comment" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "Special" })
    end
    set_indent_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_indent_hl })
    -- ERROR 通知显示更久（必须等 VeryLazy，等 snacks 替换完 vim.notify）
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        local orig_notify = vim.notify
        vim.notify = function(msg, level, opts)
          opts = opts or {}
          if level == vim.log.levels.ERROR and not opts.timeout then
            opts.timeout = 8000
          end
          return orig_notify(msg, level, opts)
        end
      end,
    })
  end,
}
