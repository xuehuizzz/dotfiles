-- 记住上次编辑位置
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- 退出插入模式时, 自动关闭粘贴模式
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- 打开下列类型文件时, 关闭代码隐藏功能
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	command = "set conceallevel=0",
})

-- 定义使用4空格缩进的语言
local four_spaces = {
	python = true,
	c = true,
	cpp = true,
	java = true,
	cs = true, -- C#
	swift = true,
	rust = true,
	go = true,
	kotlin = true,
	php = true,
}

-- 其他文件使用2空格缩进
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function()
		if not four_spaces[vim.bo.filetype] then
			vim.bo.tabstop = 2
			vim.bo.shiftwidth = 2
		end
	end,
})

-- 设置当前行高亮显示下划线, 而不是块状高亮
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bg = "NONE" })
	end,
})

-- 关闭最后一个文件时退出 nvim
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function()
		vim.schedule(function()
			local bufs = vim.tbl_filter(function(b)
				if not vim.api.nvim_buf_is_valid(b) then return false end
				if not vim.bo[b].buflisted then return false end
				if vim.bo[b].buftype ~= "" then return false end
				-- 有文件名的才算真实 buffer
				if vim.api.nvim_buf_get_name(b) ~= "" then return true end
				-- 无文件名但有内容的也算
				local lines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
				return #lines > 1 or (#lines == 1 and lines[1] ~= "")
			end, vim.api.nvim_list_bufs())
			if #bufs == 0 then
				vim.cmd("qa!")
			end
		end)
	end,
})

-- 保存时自动删除空行中的空格字符
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		-- 保存当前的搜索标记和光标位置
		local save_cursor = vim.fn.getpos(".")
		-- 删除空行中的空格
		vim.cmd([[%s/^\s\+$//e]])
		-- 恢复光标位置
		vim.fn.setpos(".", save_cursor)
	end,
})
