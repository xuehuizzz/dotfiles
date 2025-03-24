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

-- 除了python、c、cpp外，其他文件使用2空格缩进
local four_spaces = { python = true, c = true, cpp = true }
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"*"},
  callback = function()
    if not four_spaces[vim.bo.filetype] then
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
    end
  end
})
