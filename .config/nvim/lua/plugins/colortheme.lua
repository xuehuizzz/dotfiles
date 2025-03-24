return {
  {
    "rktjmp/lush.nvim", -- 添加 lush.nvim 依赖
  },
  {
    "briones-gabriel/darcula-solid.nvim",
    dependencies = { "rktjmp/lush.nvim" }, -- 声明依赖关系
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme darcula-solid]])
      -- 如果需要透明背景
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
}
