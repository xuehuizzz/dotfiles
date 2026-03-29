return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = not (vim.fn.argc(-1) == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1),
      width = 40,
      row = nil,
      col = nil,
      pane_gap = 4,
      preset = {
        keys = {
          { icon = "", key = "f", desc = "  Find File",       action = ":lua Snacks.picker.files()" },
          { icon = "", key = "r", desc = "  Recent Files",    action = ":lua Snacks.picker.recent()" },
          { icon = "", key = "w", desc = "  Find Word",       action = ":lua Snacks.picker.grep()" },
          { icon = "", key = "p", desc = "  Package Manager", action = ":Lazy" },
          { icon = "", key = "h", desc = "  Health", action = ":checkhealth" },
          { icon = "", key = "q", desc = "  Quit",            action = ":qa" },
        },
        header = [[
          ::::    ::: :::     ::: ::::::::::: ::::    ::::  
          :+:+:   :+: :+:     :+:     :+:     +:+:+: :+:+:+ 
          :+:+:+  +:+ +:+     +:+     +:+     +:+ +:+:+ +:+ 
          +#+ +:+ +#+ +#+     +:+     +#+     +#+  +:+  +#+ 
          +#+  +#+#+#  +#+   +#+      +#+     +#+       +#+ 
          #+#   #+#+#   #+#+#+#       #+#     #+#       #+# 
          ###    ####     ###     ########### ###       ### 

               ── Code  ·  Create  ·  Conquer ──]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 3 },
        { section = "startup" },
      },
    },

    -- ══════════════════════════════════════════
    --  Picker (替代 telescope.nvim)
    -- ══════════════════════════════════════════
    picker = {
      enabled = true,
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
          follow_file = true,
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
    --  Explorer (替代 neo-tree.nvim)
    -- ══════════════════════════════════════════
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    -- ══════════════════════════════════════════
    --  Notifier (替代 nvim-notify)
    -- ══════════════════════════════════════════
    notifier = {
      enabled = true,
      timeout = 3000,
      top_down = false,
      style = "compact",
      icons = {
        debug = " ",
        error = " ",
        info  = " ",
        trace = " ",
        warn  = " ",
      },
    },

    -- ══════════════════════════════════════════
    --  Indent (替代 indent-blankline.nvim)
    -- ══════════════════════════════════════════
    indent = {
      enabled = true,
      indent = {
        char = "│",
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
        },
      },
      scope = {
        enabled = true,
        char = "│",
        hl = "SnacksIndentScope",
      },
      animate = {
        enabled = false,
      },
    },

    -- ══════════════════════════════════════════
    --  Terminal (替代 toggleterm.nvim)
    -- ══════════════════════════════════════════
    terminal = {
      enabled = true,
      win = {
        style = "float",
        border = "rounded",
        width = 0.85,
        height = 0.80,
        wo = { winblend = 8 },
        on_win = function(self)
          local win = self.win
          local buf = self.buf
          if not win or not vim.api.nvim_win_is_valid(win) then return end

          local api = vim.api
          local drag = {}

          local function to_num(val)
            if type(val) == "number" then return val end
            if type(val) == "table" then return val[false] or val[1] or 0 end
            return 0
          end

          local kopts = { buffer = buf, noremap = true, silent = true }

          -- 左键拖拽: 移动窗口
          vim.keymap.set("t", "<LeftMouse>", function()
            if not api.nvim_win_is_valid(win) then return end
            local pos = vim.fn.getmousepos()
            local c = api.nvim_win_get_config(win)
            if c.relative == "" then return end
            drag = {
              mode = "move",
              anchor_row = pos.screenrow - to_num(c.row),
              anchor_col = pos.screencol - to_num(c.col),
              width = c.width, height = c.height,
            }
          end, kopts)

          vim.keymap.set("t", "<LeftDrag>", function()
            if drag.mode ~= "move" then return end
            if not api.nvim_win_is_valid(win) then drag = {} return end
            local pos = vim.fn.getmousepos()
            local max_r = vim.o.lines - drag.height - 2
            local max_c = vim.o.columns - drag.width - 2
            api.nvim_win_set_config(win, {
              relative = "editor",
              row = math.max(0, math.min(pos.screenrow - drag.anchor_row, max_r)),
              col = math.max(0, math.min(pos.screencol - drag.anchor_col, max_c)),
              width = drag.width, height = drag.height,
            })
          end, kopts)

          vim.keymap.set("t", "<LeftRelease>", function()
            if drag.mode == "move" then drag = {} end
          end, kopts)

          -- 右键拖拽: 调整大小
          vim.keymap.set("t", "<RightMouse>", function()
            if not api.nvim_win_is_valid(win) then return end
            local pos = vim.fn.getmousepos()
            local c = api.nvim_win_get_config(win)
            if c.relative == "" then return end
            drag = {
              mode = "resize",
              start_mouse_row = pos.screenrow, start_mouse_col = pos.screencol,
              start_width = c.width, start_height = c.height,
              row = to_num(c.row), col = to_num(c.col),
            }
          end, kopts)

          vim.keymap.set("t", "<RightDrag>", function()
            if drag.mode ~= "resize" then return end
            if not api.nvim_win_is_valid(win) then drag = {} return end
            local pos = vim.fn.getmousepos()
            local new_w = drag.start_width + (pos.screencol - drag.start_mouse_col)
            local new_h = drag.start_height + (pos.screenrow - drag.start_mouse_row)
            api.nvim_win_set_config(win, {
              relative = "editor",
              row = drag.row, col = drag.col,
              width = math.max(30, math.min(new_w, vim.o.columns - 2)),
              height = math.max(8, math.min(new_h, vim.o.lines - 2)),
            })
          end, kopts)

          vim.keymap.set("t", "<RightRelease>", function()
            if drag.mode == "resize" then drag = {} end
          end, kopts)

          -- 滚轮: 等比缩放
          local function zoom(dw, dh)
            if not api.nvim_win_is_valid(win) then return end
            local c = api.nvim_win_get_config(win)
            if c.relative == "" then return end
            local row, col = to_num(c.row), to_num(c.col)
            local old_w, old_h = c.width, c.height
            local new_w = math.max(30, math.min(old_w + dw, vim.o.columns - 2))
            local new_h = math.max(8, math.min(old_h + dh, vim.o.lines - 2))
            api.nvim_win_set_config(win, {
              relative = "editor",
              row = math.max(0, row - math.floor((new_h - old_h) / 2)),
              col = math.max(0, col - math.floor((new_w - old_w) / 2)),
              width = new_w, height = new_h,
            })
          end

          vim.keymap.set("t", "<ScrollWheelUp>", function() zoom(4, 2) end, kopts)
          vim.keymap.set("t", "<ScrollWheelDown>", function() zoom(-4, -2) end, kopts)

          -- 中键: 居中窗口
          vim.keymap.set("t", "<MiddleMouse>", function()
            if not api.nvim_win_is_valid(win) then return end
            local c = api.nvim_win_get_config(win)
            if c.relative == "" then return end
            c.row = math.floor((vim.o.lines - c.height) / 2)
            c.col = math.floor((vim.o.columns - c.width) / 2)
            api.nvim_win_set_config(win, c)
          end, kopts)
        end,
      },
    },

    -- ══════════════════════════════════════════
    --  Bufdelete (替代 mini.bufremove)
    -- ══════════════════════════════════════════
    bufdelete = { enabled = true },

    -- ══════════════════════════════════════════
    --  额外实用模块
    -- ══════════════════════════════════════════
    bigfile    = { enabled = true },
    quickfile  = { enabled = true },
    words      = { enabled = true },
    scroll     = { enabled = true },
    input      = { enabled = true },
    scope      = { enabled = true },
    rename     = { enabled = true },
    statuscolumn = { enabled = true },
  },

  keys = {
    -- ── Picker (文件/搜索) ──
    { "<leader>ff", function() Snacks.picker.files() end,       desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end,        desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end,     desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end,        desc = "Help tags" },
    { "<leader>fr", function() Snacks.picker.resume() end,      desc = "Resume last search" },
    { "<leader>fo", function() Snacks.picker.recent() end,      desc = "Recent files" },
    { "<leader>fw", function() Snacks.picker.grep_word() end,   desc = "Grep word under cursor" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.git_status() end,  desc = "Git status" },
    { "<leader>fp", function() Snacks.picker.projects() end,    desc = "Projects" },

    -- ── Explorer (文件树) ──
    { "<leader>e",  function() Snacks.explorer.toggle() end,    desc = "Toggle file explorer" },
    { "<leader>fe", function() Snacks.explorer.reveal() end,    desc = "Reveal current file" },

    -- ── Terminal ──
    { "<C-j>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle floating terminal" },

    -- ── Buffer delete ──
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete current buffer" },

    -- ── Notifier ──
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" },

    -- ── Words (LSP 引用导航) ──
    { "]]", function() Snacks.words.jump(vim.v.count1) end,  desc = "Next reference",     mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference",  mode = { "n", "t" } },
  },

  init = function()
    -- ── Dashboard: 固定位置，禁止任何滚动/移动 ──
    local dash_group = vim.api.nvim_create_augroup("snacks_dash_lock", { clear = true })
    local saved_mousescroll = nil

    -- 进入 dashboard 时禁用鼠标滚轮
    vim.api.nvim_create_autocmd("BufEnter", {
      group = dash_group,
      callback = function()
        if vim.bo.filetype == "snacks_dashboard" then
          saved_mousescroll = saved_mousescroll or vim.o.mousescroll
          vim.o.mousescroll = "ver:0,hor:0"
        elseif saved_mousescroll then
          vim.o.mousescroll = saved_mousescroll
          saved_mousescroll = nil
        end
      end,
    })

    -- 备用: 万一还有滚动，立刻复位
    vim.api.nvim_create_autocmd("WinScrolled", {
      group = dash_group,
      callback = function()
        if vim.bo.filetype ~= "snacks_dashboard" then return end
        vim.fn.winrestview({ topline = 1, leftcol = 0 })
      end,
    })

    -- ── Indent 高亮颜色 ──
    local function set_indent_highlights()
      vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#3b3f51" })
      vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#3d4250" })
      vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#3f444f" })
      vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#3b3f51" })
      vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#3d4250" })
      vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#3f444f" })
      vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#bd93f9" })
    end

    set_indent_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_indent_highlights,
    })
  end,
}
