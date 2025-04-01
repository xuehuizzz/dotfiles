return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local dashboard = require("dashboard")
  
    -- 添加自动命令来处理 Telescope 窗口的退出
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = "close",
          },
          n = {
            ["<esc>"] = "close",
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
          "                                                       ",
          " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "                                                       ",
          "                                                       ",
        },
        center = {
          -- {
          -- 	icon = "  ",
          -- 	icon_hl = "Title",
          -- 	desc = "Projects",
          -- 	desc_hl = "String",
          -- 	key = "p",
          -- 	key_hl = "Number",
          -- 	action = "Telescope project theme=dropdown",
          -- },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Recent Files",
            desc_hl = "String",
            key = "r",
            key_hl = "Number",
            action = "Telescope oldfiles theme=ivy",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Find File",
            desc_hl = "String",
            key = "f",
            key_hl = "Number",
            action = "Telescope find_files theme=ivy",
          },
          {
            icon = "  ",
            icon_hl = "Title",
            desc = "Find Word",
            desc_hl = "String",
            key = "w",
            key_hl = "Number",
            action = "Telescope live_grep theme=dropdown",
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
        footer = {},
      },
    })
  end,
}
