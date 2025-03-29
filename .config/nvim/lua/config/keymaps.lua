-- 可视模式下的 Tab 缩进
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- 普通模式下的 Tab 缩进
vim.keymap.set('n', '<Tab>', '>>_', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<<_', { noremap = true, silent = true })

-- 设置 Ctrl+A 全选
vim.keymap.set('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
vim.keymap.set({'i', 'v'}, '<C-a>', '<Esc>ggVG', { noremap = true, silent = true })

-- 禁用 Command+A
vim.keymap.set({'n', 'i', 'v'}, '<D-a>', '<Nop>', { noremap = true, silent = true })
