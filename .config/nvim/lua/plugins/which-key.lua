return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    preset = "modern",

    -- 更丝滑的弹出速度（避免“卡一下才出现”）
    delay = 0,

    -- UI 细节优化
    icons = {
      mappings = true,
      group = "",
      separator = "➜",
    },

    spec = {
      -- Find / Search
      { "<leader>f", group = "Find / Search" },
      { "<leader>ff", desc = "Find File" },
      { "<leader>fg", desc = "Live Grep" },
      { "<leader>fb", desc = "Find Buffer" },
      { "<leader>fr", desc = "Recent Files" },

      -- Git
      { "<leader>g", group = "Git" },
      { "<leader>gs", desc = "Status" },
      { "<leader>gc", desc = "Commit" },
      { "<leader>gp", desc = "Push" },
      { "<leader>gl", desc = "Log" },

      -- Trouble / Diagnostics
      { "<leader>x", group = "Diagnostics" },
      { "<leader>xx", desc = "Workspace Diagnostics" },
      { "<leader>xw", desc = "Workspace Diagnostics (All)" },
      { "<leader>xd", desc = "Document Diagnostics" },
      { "<leader>xq", desc = "Quickfix" },

      -- Code / LSP
      { "<leader>c", group = "Code / LSP" },
      { "<leader>ca", desc = "Code Action" },
      { "<leader>cr", desc = "Rename" },
      { "<leader>cf", desc = "Format" },
      { "<leader>cd", desc = "Definition" },

      -- Buffer
      { "<leader>b", group = "Buffer" },
      { "<leader>bn", desc = "Next Buffer" },
      { "<leader>bp", desc = "Prev Buffer" },
      { "<leader>bd", desc = "Delete Buffer" },
      { "<leader>ba", desc = "Close All Buffers" },

      -- Window
      { "<leader>w", group = "Window" },
      { "<leader>ws", desc = "Split Horizontal" },
      { "<leader>wv", desc = "Split Vertical" },
      { "<leader>wd", desc = "Close Window" },
      { "<leader>ww", desc = "Switch Window" },
    },
  },

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({
          global = true,
        })
      end,
      desc = "Show Keymaps",
    },
  },
}
