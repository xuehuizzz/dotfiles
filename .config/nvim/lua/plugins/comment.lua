return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    -- JSX/TSX/Vue/Svelte 等混合语言文件自动识别注释风格
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = { enable_autocmd = false },
    },
  },
  config = function()
    require("Comment").setup({
      -- 根据光标位置上下文自动选对注释符号
      -- 比如 Vue 文件里 <template> 用 <!-- -->，<script> 用 //
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

      -- 注释后不移动光标（sticky）
      sticky = true,

      -- 保留空行的缩进（注释空行时不会顶格）
      padding = true,
    })

    local api = require("Comment.api")

    -- 兼容不同终端对 <C-/> 的识别
    for _, key in ipairs({ "<C-/>", "<C-_>" }) do
      -- Normal：切换当前行
      vim.keymap.set("n", key, api.toggle.linewise.current, { desc = "Toggle comment" })

      -- Visual：切换选中行
      vim.keymap.set("x", key, function()
        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = "Toggle comment (visual)" })

      -- Insert：直接注释当前行，光标不动
      vim.keymap.set("i", key, function()
        api.toggle.linewise.current()
      end, { desc = "Toggle comment (insert)" })
    end

    -- 块注释 (/* */ 风格)，用 <C-S-/> 或自定义键
    vim.keymap.set("n", "gbc", api.toggle.blockwise.current, { desc = "Toggle block comment" })
  end,
}
