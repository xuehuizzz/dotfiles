return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    config = function()
      local telescope = require("telescope")
  
      telescope.setup({
        extensions = {
          project = {
            base_dirs = {
              -- "~/Projects",
              "~/.config/nvim",
            },
            hidden_files = true, -- 默认显示隐藏文件
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = true, -- 同步 nvim-tree
          },
        },
      })
  
      -- 加载 project 扩展
      telescope.load_extension("project")
  
      -- 设置快捷键
      local keymap = vim.keymap
      keymap.set("n", "<leader>fp", ":Telescope project<CR>", { noremap = true, silent = true })
      keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
      keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
      keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
      keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })
    end,
  },
}
