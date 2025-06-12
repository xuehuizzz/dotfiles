return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
  },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "javascript",
      "typescript",
      "vim",
      "vimdoc",
      "bash",
      "html",
      "css",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "dockerfile",
      "go",
      "sql",
      "terraform",
      "toml",
      "gitignore",
      "java",
      "groovy",        -- 如果你确实需要，可保留，否则建议移除
      "graphql",
      "make",
      "cmake",
      "tsx",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = {},
    },
    indent = {
      enable = true,
      disable = { "ruby" },  -- 你原本指定的内容仍保留
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  
    -- rainbow-delimiters 配置
    local rainbow_delimiters = require("rainbow-delimiters")
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterYellow",
        "RainbowDelimiterViolet",
        "RainbowDelimiterBlue",
      },
    }
  end,
}

