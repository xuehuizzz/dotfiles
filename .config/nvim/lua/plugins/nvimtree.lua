return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local nvimtree = require("nvim-tree")
  
    -- 禁用默认文件浏览器netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  
    nvimtree.setup({
      view = {
        width = 35,
        -- relativenumber = true,  -- 显示相对行号
      },
  
      -- 设置文件/夹 图标
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- 文件夹关闭的箭头
              arrow_open = "", -- 文件夹打开的箭头
            },
          },
  
          -- show中配置为隐藏所有图标信息, 整个注释掉即可恢复展示
          show = {
            file = false, -- 不显示文件图标
            folder = false, -- 不显示文件夹图标
            folder_arrow = false, -- 不显示文件夹箭头
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        git_ignored = false,
        dotfiles = false, -- 不隐藏点文件
        custom = { -- 隐藏如下文件
          "^.git$",
          "^node_modules$",
          "^dist$",
          "^.next$",
          "^.idea$",
          "^.vscode$",
          "\\.pyc$",
          "__pycache__",
          ".DS_Store",
        },
      },
    })
  
    -- local keymap = vim.keymap
    -- keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- 打开/折叠目录
    -- keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- 定为到当前文件在文件树中的位置
    -- keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- 折叠文件树
    -- keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- 刷新文件树
  end,
}
