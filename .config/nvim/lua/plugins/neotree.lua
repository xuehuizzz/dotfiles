return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = false, -- 如果是最后一个窗口则关闭
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        file_icon = {
          enabled = false,
        },
        name = {
          enabled = true, -- 确保显示文件名
          use_git_status_colors = false,
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      filesystem = {
        follow_current_file = true,     -- 打开自动跟随
        hijack_netrw_behavior = "open_default",  -- 使用默认行为
        components = {
          icon = false,
        },
        renderers = {
          file = {
            { "name", use_git_status_colors = false },
          },
          directory = {
            { "name", use_git_status_colors = false },
          },
        },
        filtered_items = {
          visible = false, -- 当设置为 true 时会显示被过滤的项目
          hide_dotfiles = false, -- 隐藏以点开头的文件
          hide_gitignored = false, -- 隐藏 git ignore 的文件
          hide_hidden = false, -- 隐藏系统隐藏文件
          hide_by_pattern = { -- 使用 lua 模式匹配语法
            "*.meta",
            "*/src/*/tsconfig.json",
          },
          never_show = { -- 永远不显示这些文件
            ".DS_Store",
            "thumbs.db",
            ".idea",
            "__pycache__",
            ".idea",
            ".git",
            "ruff_cache",
            "node_modules",
          },
        },
      },
      window = {
        width = 30,
        mappings = {
          ["O"] = "expand_all_nodes",   -- 大写 O 展开所有目录
          ["C"] = "close_all_nodes",    -- 大写 C 关闭所有目录
          ["<space>"] = "toggle_node",  -- 空格键, 打开/关闭当前目录
          ["<cr>"] = "open",  -- 回车键, 打开文件
          ["v"] = "open_vsplit",  -- 垂直分屏打开文件
          ["s"] = "open_split",   -- 水平分屏打开文件
          ["a"] = "add",  -- 新建文件
          ["A"] = "add_directory",  -- 新建目录
          ["d"] = "delete",  -- 删除文件/目录
          ["r"] = "rename",  -- 重命名文件/目录
          ["y"] = "copy_to_clipboard",  -- 复制到剪贴板
          ["x"] = "cut_to_clipboard",  -- 剪切到剪贴板
          ["p"] = "paste_from_clipboard",  -- 从剪贴板粘贴
          ["c"] = "copy",  -- 复制文件/目录
          ["m"] = "move",  -- 移动文件/目录
        },
      },
    })

    -- 设置快捷键
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })
  end,
}
