local keymap = vim.keymap

local function map(mode, lhs, rhs, desc)
  keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Do things without affecting the registers
map("n", "x", '"_x', "Delete char without yanking")
map("n", "<Leader>p", '"0p', "Paste from yank register (after)")
map("n", "<Leader>P", '"0P', "Paste from yank register (before)")
map("v", "<Leader>p", '"0p', "Paste from yank register (visual)")
map("n", "<Leader>c", '"_c', "Change without yanking")
map("n", "<Leader>C", '"_C', "Change to EOL without yanking")
map("v", "<Leader>c", '"_c', "Change without yanking (visual)")
map("v", "<Leader>C", '"_C', "Change to EOL without yanking (visual)")
map("n", "<Leader>d", '"_d', "Delete without yanking")
map("n", "<Leader>D", '"_D', "Delete to EOL without yanking")
map("v", "<Leader>d", '"_d', "Delete without yanking (visual)")
map("v", "<Leader>D", '"_D', "Delete to EOL without yanking (visual)")

-- Tab indent (visual mode)
map("v", "<Tab>", ">gv", "Indent and reselect")
map("v", "<S-Tab>", "<gv", "Outdent and reselect")

-- Tab indent (normal mode)  NOTE: overrides <C-i> (jumplist forward) in terminal
map("n", "<Tab>", ">>_", "Indent current line")
map("n", "<S-Tab>", "<<_", "Outdent current line")

-- Select all  NOTE: overrides default <C-a> (increment number)
map("n", "<C-a>", "ggVG", "Select all")
map({ "i", "v" }, "<C-a>", "<Esc>ggVG", "Select all")

-- Disable Command+A
map({ "n", "i", "v" }, "<D-a>", "<Nop>", "Disable Cmd+A")

-- Duplicate line  NOTE: overrides default <C-d> (scroll half page down)
map("n", "<C-d>", "yyp", "Duplicate line below")
map("i", "<C-d>", "<Esc>yypa", "Duplicate line below (insert)")
