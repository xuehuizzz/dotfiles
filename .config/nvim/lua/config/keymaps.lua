-- 可视模式下的 Tab 缩进
vim.keymap.set('v', '<Tab>', '>gv')
vim.keymap.set('v', '<S-Tab>', '<gv')

-- 普通模式下的 Tab 缩进
vim.keymap.set('n', '<Tab>', '>>_')
vim.keymap.set('n', '<S-Tab>', '<<_')

-- 设置 Ctrl+A 全选
vim.keymap.set('n', '<C-a>', 'ggVG')  -- 普通模式下的全选
vim.keymap.set('i', '<C-a>', '<Esc>ggVG')  -- 插入模式下的全选
vim.keymap.set('v', '<C-a>', '<Esc>ggVG')  -- 可视模式下的全选
