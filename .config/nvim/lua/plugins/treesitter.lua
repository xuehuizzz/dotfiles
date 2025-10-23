return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim", -- ✅ 替换掉旧版 p00f/nvim-ts-rainbow
  },
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "vimdoc",
      "vim",
      "regex",
      "terraform",
      "sql",
      "dockerfile",
      "toml",
      "json",
      "java",
      "groovy",
      "go",
      "gitignore",
      "graphql",
      "yaml",
      "make",
      "cmake",
      "markdown",
      "markdown_inline",
      "bash",
      "tsx",
      "css",
      "html",
    },

    -- 自动安装未安装的语法
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "ruby" },
    },

    indent = { enable = true, disable = { "ruby" } },
  },

  config = function(_, opts)
    -- treesitter 基础配置
    require("nvim-treesitter.configs").setup(opts)

    -- ✅ rainbow-delimiters 配置
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
      highlight = {
        -- 自定义你的彩虹括号配色（与原来的保持一致）
        "RainbowDelimiterYellow", -- "#F9D749"
        "RainbowDelimiterViolet", -- "#CC78D1"
        "RainbowDelimiterBlue",   -- "#479FF8"
      },
    }
  end,
}

