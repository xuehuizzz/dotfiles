return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local api = vim.api

		local function to_num(val)
			if type(val) == "number" then return val end
			if type(val) == "table" then return val[false] or val[1] or 0 end
			return 0
		end

		local function move_win(win, dx, dy)
			if not api.nvim_win_is_valid(win) then return end
			local cfg = api.nvim_win_get_config(win)
			if cfg.relative == "" then return end
			cfg.row = math.max(0, to_num(cfg.row) + dy)
			cfg.col = math.max(0, to_num(cfg.col) + dx)
			api.nvim_win_set_config(win, cfg)
		end

		local function resize_win(win, dw, dh)
			if not api.nvim_win_is_valid(win) then return end
			local cfg = api.nvim_win_get_config(win)
			if cfg.relative == "" then return end
			cfg.row = to_num(cfg.row)
			cfg.col = to_num(cfg.col)
			cfg.width = math.max(30, cfg.width + dw)
			cfg.height = math.max(8, cfg.height + dh)
			api.nvim_win_set_config(win, cfg)
		end

		local function center_win(win)
			if not api.nvim_win_is_valid(win) then return end
			local cfg = api.nvim_win_get_config(win)
			if cfg.relative == "" then return end
			cfg.row = math.floor((vim.o.lines - cfg.height) / 2)
			cfg.col = math.floor((vim.o.columns - cfg.width) / 2)
			api.nvim_win_set_config(win, cfg)
		end

		local mouse_events = {
			"<LeftMouse>", "<2-LeftMouse>", "<3-LeftMouse>",
			"<RightMouse>", "<2-RightMouse>", "<3-RightMouse>",
			"<MiddleMouse>", "<2-MiddleMouse>", "<3-MiddleMouse>",
			"<LeftDrag>", "<RightDrag>", "<MiddleDrag>",
			"<LeftRelease>", "<RightRelease>", "<MiddleRelease>",
			"<ScrollWheelUp>", "<ScrollWheelDown>",
			"<ScrollWheelLeft>", "<ScrollWheelRight>",
		}

		-- ═══ 终端光标: 闪烁竖线 ═══
		vim.opt.guicursor:append(
			"t:ver25-blinkon400-blinkoff400-blinkwait300-Cursor"
		)

		require("toggleterm").setup({
			open_mapping = [[<C-j>]],
			direction = "float",
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			persist_size = true,
			persist_mode = true,
			close_on_exit = true,
			clear_env = false,
			auto_scroll = true,
			shell = vim.o.shell,
			float_opts = {
				border = "rounded",
				width = function()
					return math.floor(vim.o.columns * 0.85)
				end,
				height = function()
					return math.floor(vim.o.lines * 0.8)
				end,
				winblend = 8,
			},
			highlights = {
				FloatBorder = { link = "FloatBorder" },
				NormalFloat = { link = "NormalFloat" },
			},
			on_create = function(term)
				vim.opt.laststatus = 3
				local buf = term.bufnr
				local opts = { buffer = buf, noremap = true, silent = true }

				for _, ev in ipairs(mouse_events) do
					vim.keymap.set("t", ev, "<Nop>", opts)
				end

				for _, ev in ipairs(mouse_events) do
					vim.keymap.set("n", ev, function()
						vim.cmd("startinsert!")
					end, opts)
				end

				api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
					buffer = buf,
					callback = function()
						vim.schedule(function()
							if api.nvim_buf_is_valid(buf) and api.nvim_get_current_buf() == buf then
								vim.cmd("startinsert!")
							end
						end)
					end,
				})
			end,
			on_open = function(term)
				vim.schedule(function()
					vim.cmd("startinsert!")
				end)

				local win = term.window
				if not win or not api.nvim_win_is_valid(win) then return end
				local cfg = api.nvim_win_get_config(win)
				if cfg.relative == "" then return end

				local opts = { buffer = term.bufnr, noremap = true, silent = true }

				vim.keymap.set("t", "<A-h>", function() move_win(win, -3, 0) end, opts)
				vim.keymap.set("t", "<A-l>", function() move_win(win, 3, 0) end, opts)
				vim.keymap.set("t", "<A-k>", function() move_win(win, 0, -2) end, opts)
				vim.keymap.set("t", "<A-j>", function() move_win(win, 0, 2) end, opts)

				vim.keymap.set("t", "<A-Left>",  function() resize_win(win, -3, 0) end, opts)
				vim.keymap.set("t", "<A-Right>", function() resize_win(win, 3, 0) end, opts)
				vim.keymap.set("t", "<A-Up>",    function() resize_win(win, 0, -2) end, opts)
				vim.keymap.set("t", "<A-Down>",  function() resize_win(win, 0, 2) end, opts)

				vim.keymap.set("t", "<A-c>", function() center_win(win) end, opts)
			end,
		})

		vim.keymap.set({ "n", "t" }, "<C-\\>", "<Cmd>ToggleTerm direction=float<CR>", {
			desc = "Toggle floating terminal",
			silent = true,
		})
	end,
}
