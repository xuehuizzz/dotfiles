return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local mode = {
      "mode",
      fmt = function(str)
        return str     --  str:sub(1,1)   只显示模式首字母
      end,
    }

		local filename = {
			"filename",
			file_status = true, -- displays file status (readonly status, modified status)
			path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
		}

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
      cond = hide_in_width,
    }
		-- 添加 EOL 组件
    local eol = {
      "fileformat",
      symbols = {
        unix = "LF",
        dos = "CRLF",
        mac = "CR",
      },
      cond = hide_in_width,
    }
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "dracula", 
        section_separators = { left = "", right = "" },  -- 控制分段之间的分隔符
        component_separators = { left = "", right = "" },  -- 控制同一分段内不同组件的分隔符  
        disabled_filetypes = { "alpha", "neo-tree" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { "branch" },
        lualine_c = { filename },
        lualine_x = {
          diagnostics,
          diff,
          eol,
          { "encoding", cond = hide_in_width },
        },
        lualine_y = { "location" },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "fugitive" },
		})
	end,
}
