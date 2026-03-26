return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("Comment").setup()

    local api = require("Comment.api")
    local opts = { noremap = true, silent = true }

    -- Normal 模式：切换当前行注释
    vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, opts)

    -- Visual 模式：切换选中行注释
    vim.keymap.set("v", "<C-/>", function()
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      api.toggle.linewise(vim.fn.visualmode())
    end, opts)
  end,
}
