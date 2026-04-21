return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>x", group = "Trouble" },
      { "<leader>c", group = "Code" },
      { "<leader>b", group = "Buffer" },
      { "<leader>w", group = "Window" },
    },
  },
  keys = {
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" },
  },
}
