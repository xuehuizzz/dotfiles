local exclude = {
  ".git",
  "node_modules",
  "__pycache__",
  ".venv",
  ".ruff_cache",
  ".mypy_cache",
  ".pytest_cache",
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    -- ══════════════════════════════════════════
    --  Dashboard
    -- ══════════════════════════════════════════
    dashboard = {
      enabled = vim.fn.argc(-1) == 0,
      width = 40,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "r", desc = "Recent Files",    action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "w", desc = "Find Word",       action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "p", desc = "Package Manager", action = ":Lazy" },
          { icon = " ", key = "h", desc = "Health",          action = ":checkhealth" },
          { icon = " ", key = "c", desc = "Config",          action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
        },
        header = [[
          ::::    ::: :::     ::: ::::::::::: ::::    ::::  
          :+:+:   :+: :+:     :+:     :+:     +:+:+: :+:+:+ 
          :+:+:+  +:+ +:+     +:+     +:+     +:+ +:+:+ +:+ 
          +#+ +:+ +#+ +#+     +:+     +#+     +#+  +:+  +#+ 
          +#+  +#+#+#  +#+   +#+      +#+     +#+       +#+ 
          #+#   #+#+#   #+#+#+#       #+#     #+#       #+# 
          ###    ####     ###     ########### ###       ### 

             ── 🌈Code  ·  Create  ·  Conquer🌈 ──]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 3 },
        { section = "startup" },
      },
    },

    -- ══════════════════════════════════════════
    --  Picker
    -- ══════════════════════════════════════════
    picker = {
      enabled = true,
      sources = {
        -- ✅ Review #2: 共享 exclude 变量
        files = { hidden = true, exclude = exclude },
        explorer = {
          hidden = true,
          follow_file = true,
          exclude = exclude,
          layout = {
            preset = "sidebar",
            preview = false,
            layout = { width = 30 },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
            ["<C-q>"] = { "qflist", mode = { "i", "n" } },
          },
        },
      },
      layout = {
        preset = "telescope",
        layout = { width = 0.87, height = 0.80 },
      },
    },

    -- ══════════════════════════════════════════
    --  Explorer
    -- ══════════════════════════════════════════
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    -- ══════════════════════════════════════════
    --  Notifier
    -- ══════════════════════════════════════════
    notifier = {
      enabled = true,
      timeout = 3000,
      top_down = false,
      style = "compact",
    },

    -- ══════════════════════════════════════════
    --  Indent
    -- ══════════════════════════════════════════
    indent = {
      enabled = true,
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
        char = "│",
      },
      animate = { enabled = false },
    },

    -- ══════════════════════════════════════════
    --  Terminal
    -- ══════════════════════════════════════════
    terminal = {
      enabled = true,
      win = {
        style = "float",
        border = "rounded",
        width = 0.85,
        height = 0.80,
      },
    },

    -- ══════════════════════════════════════════
    --  实用模块 (开箱即用)
    -- ══════════════════════════════════════════
    bufdelete    = { enabled = true },
    bigfile      = { enabled = true },
    quickfile    = { enabled = true },
    words        = { enabled = true },
    scroll       = { enabled = true },
    input        = { enabled = true },
    scope        = { enabled = true },
    rename       = { enabled = true },
    statuscolumn = { enabled = true },
  },

  -- ═══════════════════════════════════════════════════════
  --  Keymaps
  -- 统一前缀，消除冲突
  --    <leader>f*  →  Picker (find/search)
  --    <leader>e   →  Explorer
  --    <leader>t   →  Terminal        ← 不再用 <C-\>，避免与 <C-\><C-n> 冲突
  --    <leader>b*  →  Buffer
  --    <leader>u*  →  UI utilities
  -- ═══════════════════════════════════════════════════════
  keys = {
    -- ── Picker ──
    { "<leader>ff", function() Snacks.picker.files() end,       desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end,        desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end,        desc = "Help tags" },
    { "<leader>fr", function() Snacks.picker.resume() end,      desc = "Resume search" },
    { "<leader>fo", function() Snacks.picker.recent() end,      desc = "Recent files" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,   desc = "Grep cursor word" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.git_status() end,  desc = "Git status" },
    { "<leader>fp", function() Snacks.picker.projects() end,    desc = "Projects" },

    -- ── Explorer ──
    { "<leader>e",  function() Snacks.explorer.toggle() end,                     desc = "Toggle explorer" },
    { "<leader>fe", function() Snacks.explorer.open({ follow_file = true }) end, desc = "Reveal in explorer" },

    -- ── Terminal ──
    { "<C-j>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },

    -- ── Buffer ──
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },

    -- ── UI ──
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },

    -- ── Words (LSP references) ──
    { "]]", function() Snacks.words.jump(vim.v.count1) end,  mode = { "n", "t" }, desc = "Next reference" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, mode = { "n", "t" }, desc = "Prev reference" },
  },

  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_dashboard",
      callback = function(ev)
        local buf = ev.buf
        local win = vim.fn.bufwinid(buf)
        if win ~= -1 then
          vim.wo[win].scrolloff = 999
        end
        -- buffer 内屏蔽滚轮
        for _, key in ipairs({ "<ScrollWheelUp>", "<ScrollWheelDown>" }) do
          vim.keymap.set("n", key, "<Nop>", { buffer = buf, silent = true })
        end
      end,
    })

    local function set_indent_hl()
      vim.api.nvim_set_hl(0, "SnacksIndent",      { link = "Comment" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope",  { link = "Special" })
    end
    set_indent_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_indent_hl })
  end,
}
