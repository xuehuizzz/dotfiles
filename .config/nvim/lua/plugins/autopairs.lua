return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",

  dependencies = {
    "hrsh7th/nvim-cmp",
  },

  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true, -- ⭐ Treesitter 智能判断（强烈推荐）
      map_cr = true,   -- 回车自动处理括号
      map_bs = true,   -- 退格智能删除成对符号

      disable_filetype = { "TelescopePrompt", "vim" },

      enable_check_bracket_line = true,

      ignored_next_char = "[%w%.]",

      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        before_key = "h",
        after_key = "l",
        cursor_pos_before = true,
        keys = "asdfghjklqwertyuiopzxcvbnm",
      },
    })

    -- =========================
    -- cmp 联动（关键优化）
    -- =========================
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )

    -- =========================
    -- 特殊规则（可选增强）
    -- =========================
    local Rule = require("nvim-autopairs.rule")

    -- Lua 注释自动补全优化（示例）
    autopairs.add_rules({
      Rule("--", "  ", "lua")
        :with_pair(function()
          return false
        end),
    })
  end,
}
