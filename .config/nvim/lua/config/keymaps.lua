local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- 可视模式下的 Tab 缩进
keymap.set("v", "<Tab>", ">gv", opts)
keymap.set("v", "<S-Tab>", "<gv", opts)

-- 普通模式下的 Tab 缩进
keymap.set("n", "<Tab>", ">>_", opts)
keymap.set("n", "<S-Tab>", "<<_", opts)

-- 设置 Ctrl+A 全选
keymap.set("n", "<C-a>", "ggVG", opts)
keymap.set({ "i", "v" }, "<C-a>", "<Esc>ggVG", opts)

-- 禁用 Command+A
keymap.set({ "n", "i", "v" }, "<D-a>", "<Nop>", opts)

-- 复制当前行并粘贴到下一行
keymap.set("n", "<C-d>", "yyp", opts)
keymap.set("i", "<C-d>", "<Esc>yypi", opts)
