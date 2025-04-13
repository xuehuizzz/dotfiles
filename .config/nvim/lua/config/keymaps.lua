local opts = { noremap = true, silent = true }



-- 可视模式下的 Tab 缩进
vim.keymap.set('v', '<Tab>', '>gv', opts)
vim.keymap.set('v', '<S-Tab>', '<gv', opts)

-- 普通模式下的 Tab 缩进
vim.keymap.set('n', '<Tab>', '>>_', opts)
vim.keymap.set('n', '<S-Tab>', '<<_', opts)

-- 设置 Ctrl+A 全选
vim.keymap.set('n', '<C-a>', 'ggVG', opts)
vim.keymap.set({'i', 'v'}, '<C-a>', '<Esc>ggVG', opts)

-- 禁用 Command+A
vim.keymap.set({'n', 'i', 'v'}, '<D-a>', '<Nop>', opts)
