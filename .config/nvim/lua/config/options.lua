-- 1. Leader Keys
-- Must be set before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Disable Unnecessary Providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- 3. Basic Settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.title = true

vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- GUI font
vim.opt.guifont = "Maple Mono NF CN:h12"

-- 4. Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.autoindent = true
vim.opt.smartindent = true

-- 5. Search Settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true

-- 6. Visual Settings
-- Cursor line is controlled by autocmds
vim.opt.cursorline = false

vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.matchtime = 2

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

vim.opt.ruler = true
vim.opt.conceallevel = 0

vim.opt.showbreak = "↪ "
vim.opt.linebreak = false
vim.opt.breakindent = false

-- Completion popup
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.pumheight = 10
vim.opt.pumblend = 10

-- Floating window border (Neovim 0.11+)
vim.opt.winborder = "rounded"

-- Diff view
vim.opt.fillchars:append("diff:╱")

-- 7. File Handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Persistent undo
local undodir = vim.fn.expand("~/.cache/nvim/undodir")

vim.fn.mkdir(undodir, "p")

vim.opt.undofile = true
vim.opt.undodir = undodir

-- 8. Performance and Timing
vim.opt.updatetime = 300

vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

-- 9. Completion and File Search
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")

vim.opt.wildmode = "longest:full,full"

vim.opt.wildignore:append({
    "*/node_modules/*",
    "*.o",
    "*.obj",
    "*.pyc",
    "*.class",
    "*.jar",
})

-- 10. Clipboard
vim.opt.clipboard:append("unnamedplus")

-- 11. Cursor Settings
vim.opt.guicursor =
    "n-v-c-sm-i-ci-ve-r-cr-o:ver25,t:ver25-blinkon400-blinkoff400-blinkwait300-Cursor"

-- 12. Folding Settings
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- 13. Split Behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 14. Terminal and Input
vim.opt.virtualedit = "onemore"
vim.opt.backspace = "indent,eol,start"

vim.opt.errorbells = false
vim.opt.visualbell = false

-- 15. Built-in netrw
vim.g.netrw_keepdir = 0
vim.g.netrw_localcopydircmd = "cp -r"

-- 16. LSP Diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = "",
        spacing = 4,
        source = true,
        severity = {
            min = vim.diagnostic.severity.INFO,
        },
    },

    signs = false,

    update_in_insert = false,

    underline = true,

    severity_sort = true,

    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})

-- 17. Disable Unnecessary Built-in Plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",

    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",

    "2html_plugin",
    "tohtml",

    "getscript",
    "getscriptPlugin",

    "logipat",
    "matchit",
    "rrhelper",

    "spellfile_plugin",

    "vimball",
    "vimballPlugin",
}

for _, plugin in ipairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- 18. Custom Filetypes
vim.filetype.add({
    extension = {
        mjml = "html",
    },
})
