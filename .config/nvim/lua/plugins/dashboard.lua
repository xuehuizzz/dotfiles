return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local dashboard = require("dashboard")
  
    -- Telescope 配置优化
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = "close",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
          n = {
            ["<esc>"] = "close",
          },
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
  
    dashboard.setup({
      theme = "doom",
      config = {
        header = {
          "                                                       ",
          "                                                       ",
          " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "                                                       ",
        },
        center = {
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Find File",
            desc_hl = "String",
            key = "f",
            key_hl = "Number",
            action = "Telescope find_files hidden=true",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Recent Files",
            desc_hl = "String",
            key = "r",
            key_hl = "Number",
            action = "Telescope oldfiles",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Find Word",
            desc_hl = "String",
            key = "w",
            key_hl = "Number",
            action = "Telescope live_grep",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "New File",
            desc_hl = "String",
            key = "n",
            key_hl = "Number",
            action = "enew",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Package Manager",
            desc_hl = "String",
            key = "p",
            key_hl = "Number",
            action = "Lazy",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Quit Neovim",
            desc_hl = "String",
            key = "q",
            key_hl = "Number",
            action = "qa",
          },
        },
        -- footer = {
        --     "",
        --     "🚀 Ready to code!",
        --     "neovim loaded " .. #vim.tbl_keys(require("lazy").plugins()) .. " plugins",
        -- },
        footer = {},
      },
    })
  
    -- 设置背景透明
    vim.cmd([[
            autocmd ColorScheme * highlight DashboardHeader guifg=#6272a4
            autocmd ColorScheme * highlight DashboardCenter guifg=#f8f8f2
            autocmd ColorScheme * highlight DashboardFooter guifg=#6272a4
        ]])
  end,
}
