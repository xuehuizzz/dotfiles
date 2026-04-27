return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        -- 核心开发语言（高频）
        "lua",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "bash",
        "sql",
        "json",
        "yaml",
        "html",
        "css",

        -- 编辑器/工具链
        "vim",
        "vimdoc",
        "regex",

        -- 基础工程
        "dockerfile",
        "toml",
        "markdown",
        "markdown_inline",
      },

      auto_install = true,

      highlight = {
        enable = true,
        -- 大文件禁用，避免卡顿
        disable = function(_, buf)
          local max_filesize = 200 * 1024 -- 200 KB
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },

      indent = { enable = true },

      -- 增量选择：用 <CR> 逐步扩大选区，<BS> 缩小
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    })

    -- Rainbow Delimiters 配置
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        commonlisp = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        latex = "rainbow-blocks",
      },
      priority = {
        [""] = 110,
        lua = 210,
      },
      highlight = {
        "RainbowDelimiterYellow",
        "RainbowDelimiterViolet",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterCyan",
        "RainbowDelimiterRed",
      },
    }
  end,
}
