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
  
      local function set_highlights(transparent_bg)
        local bg_color = transparent_bg and "none" or "#2B2B2B"
        vim.api.nvim_set_hl(0, "Normal", { bg = bg_color })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color })
        vim.api.nvim_set_hl(0, "Visual", {
          bg = "#2F4F75", -- 可视模式背景色
          fg = "NONE", -- 保持文字颜色不变
        })
      end
  
      set_highlights(false) -- 默认使用非透明背景
    end,
  },
}
