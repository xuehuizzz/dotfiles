return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = { follow_files = true },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end

      -- 跳转 hunk
      map("n", "]h", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.nav_hunk("next") end)
        return "<Ignore>"
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.nav_hunk("prev") end)
        return "<Ignore>"
      end, "Prev Hunk")

      -- Hunk 操作
      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>",   "Stage Hunk")
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>",   "Reset Hunk")
      map("n",          "<leader>hS", gs.stage_buffer,              "Stage Buffer")
      map("n",          "<leader>hu", gs.undo_stage_hunk,           "Undo Stage Hunk")
      map("n",          "<leader>hR", gs.reset_buffer,              "Reset Buffer")
      map("n",          "<leader>hp", gs.preview_hunk,              "Preview Hunk")
      map("n",          "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n",          "<leader>hd", gs.diffthis,                  "Diff This")
      map("n",          "<leader>hD", function() gs.diffthis("~") end, "Diff This ~")
      map("n",          "<leader>ht", gs.toggle_current_line_blame, "Toggle Line Blame")

      -- 文本对象
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
    end,
  },
}
