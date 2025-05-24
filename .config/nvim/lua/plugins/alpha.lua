return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
  
    -- 设置标题
    dashboard.section.header.val = {
      "",
      "",
      "",
      "",
      " ██╗  ██╗██╗   ██╗███████╗██╗  ██╗██╗   ██╗██╗",
      " ╚██╗██╔╝██║   ██║██╔════╝██║  ██║██║   ██║██║",
      "  ╚███╔╝ ██║   ██║█████╗  ███████║██║   ██║██║",
      "  ██╔██╗ ██║   ██║██╔══╝  ██╔══██║██║   ██║██║",
      " ██╔╝ ██╗╚██████╔╝███████╗██║  ██║╚██████╔╝██║",
      " ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝",
      "",
      "",
    }
  
    -- 设置按钮
    dashboard.section.buttons.val = {
      dashboard.button("f", "  Find File", ":Telescope find_files hidden=true <CR>"),
      dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
      dashboard.button("w", "  Find Word", ":Telescope live_grep <CR>"),
      -- dashboard.button("n", "  New File", ":enew <CR>"),
      dashboard.button("p", "  Package Manager", ":Lazy <CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    }
  
    -- 设置页脚
    dashboard.section.footer.val = {}
  
    -- 设置布局
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }
  
    -- 设置选项
    dashboard.config.opts.noautocmd = true
  
    -- 设置 Telescope 配置
    require("telescope").setup({
      defaults = {
        mappings = {
          i = { ["<esc>"] = "close" },
          n = { ["<esc>"] = "close" },
        },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
        },
      },
    })
  
    -- 应用配置
    alpha.setup(dashboard.config)
  
    -- 设置高亮
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#6272a4" })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#f8f8f2" })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6272a4" })
      end,
    })
  end,
}
