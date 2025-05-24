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
            hidden_files = true,
            theme = "dropdown",
            order_by = "asc",
            sorting_strategy = "ascending",
            search_by = "title",
            sync_with_nvim_tree = true,
            layout_config = {
              horizontal = {
                prompt_position = "top",
              },
            },
          },
        },
      })
  
      -- 加载 project 扩展
      telescope.load_extension("project")
  
      -- 设置快捷键
      local keymap = vim.keymap
      keymap.set("n", "<Leader>fp", ":Telescope project<CR>", { noremap = true, silent = true })
      keymap.set("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
      keymap.set("n", "<Leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
      keymap.set("n", "<Leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
      keymap.set("n", "<Leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })
    end,
  },
}
