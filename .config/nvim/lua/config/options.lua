-- 必须在加载插件之前设置
vim.g.mapleader = " "          -- 设置全局 leader 键为空格
vim.g.maplocalleader = " "     -- 设置局部 leader 键为空格

-- 禁用不需要的外部语言提供者，加快启动速度
vim.g.loaded_ruby_provider = 0   -- 禁用 Ruby 提供者
vim.g.loaded_perl_provider = 0   -- 禁用 Perl 提供者

-- 基础编辑器设置
vim.opt.number = true            -- 显示绝对行号
vim.opt.relativenumber = false   -- 不显示相对行号
vim.opt.title = true             -- 在终端标题栏显示文件名
vim.opt.wrap = false             -- 关闭自动换行
vim.opt.scrolloff = 10           -- 光标距离顶部/底部至少保留 10 行
vim.opt.sidescrolloff = 8        -- 光标距离左右边缘至少保留 8 列
vim.opt.mouse = "a"              -- 启用鼠标支持（所有模式）
vim.opt.termguicolors = true     -- 启用真彩色支持
vim.opt.background = "dark"      -- 使用深色背景主题
vim.opt.encoding = "utf-8"       -- 内部使用的字符编码
vim.opt.fileencoding = "utf-8"   -- 写入文件时的默认编码

-- GUI font
vim.opt.guifont = "Maple Mono NF CN:h12"  -- 设置 GUI 字体（仅在 GUI 客户端生效）

-- 缩进相关设置
vim.opt.expandtab = true         -- 使用空格代替 Tab
vim.opt.tabstop = 4              -- Tab 显示为 4 个空格宽度
vim.opt.shiftwidth = 4           -- 自动缩进使用 4 个空格
vim.opt.softtabstop = 4          -- 按 Backspace 时删除 4 个空格
vim.opt.autoindent = true        -- 新行自动继承上一行的缩进
vim.opt.smartindent = true       -- 根据语法智能缩进（如 C 风格）

-- 搜索相关设置
vim.opt.ignorecase = true        -- 搜索时忽略大小写
vim.opt.smartcase = true         -- 如果搜索词包含大写，则区分大小写
vim.opt.incsearch = true         -- 输入时实时高亮匹配结果
vim.opt.hlsearch = true          -- 高亮所有匹配结果
vim.opt.wrapscan = true          -- 搜索到文件末尾后从开头继续

-- 视觉与界面设置
-- Cursor line is controlled by autocmds
vim.opt.cursorline = false       -- 默认关闭当前行高亮（由自动命令控制）
vim.opt.signcolumn = "yes"       -- 始终显示符号列（避免跳动）
vim.opt.showmatch = true         -- 输入括号时高亮匹配的括号
vim.opt.matchtime = 2            -- 匹配括号高亮持续时间（单位：0.1 秒）
vim.opt.cmdheight = 0            -- 命令行高度为 0（使用浮动命令行）
vim.opt.laststatus = 3           -- 全局状态栏（所有窗口共用一个）
vim.opt.ruler = true             -- 在状态栏显示光标位置
vim.opt.conceallevel = 0         -- 不隐藏任何字符（如 markdown 的 *）
vim.opt.showbreak = "↪ "         -- 软换行时的提示符号
vim.opt.linebreak = false        -- 不在单词中间换行
vim.opt.breakindent = false      -- 软换行后不保持缩进

-- Completion popup
vim.opt.completeopt = "menuone,noinsert,noselect"  -- 补全菜单行为：有菜单、不自动插入、不自动选择
vim.opt.pumheight = 10           -- 弹出菜单最多显示 10 项
vim.opt.pumblend = 10            -- 弹出菜单透明度（0-100）

-- Floating window border (Neovim 0.11+)
vim.opt.winborder = "rounded"    -- 浮动窗口使用圆角边框

-- Diff view
vim.opt.fillchars:append("diff:╱")  -- Diff 视图中删除行使用 ╱ 符号填充

-- 文件处理与备份设置
vim.opt.backup = false           -- 不创建备份文件
vim.opt.writebackup = false      -- 写入时不创建备份
vim.opt.swapfile = false         -- 不创建交换文件

-- Persistent undo
local undodir = vim.fn.expand("~/.cache/nvim/undodir")  -- 撤销文件存储目录
vim.fn.mkdir(undodir, "p")       -- 如果目录不存在则创建
vim.opt.undofile = true          -- 启用持久化撤销
vim.opt.undodir = undodir        -- 设置撤销文件目录

-- 性能与超时设置
vim.opt.updatetime = 300         -- CursorHold 事件触发间隔（毫秒）
vim.opt.timeoutlen = 500         -- 映射序列等待时间（毫秒）
vim.opt.ttimeoutlen = 0          -- 终端键码超时时间（0 表示立即）

-- 补全与文件搜索设置
vim.opt.iskeyword:append("-")    -- 将 - 视为单词的一部分（方便跳转）
vim.opt.path:append("**")        -- 文件搜索时递归查找子目录
vim.opt.wildmode = "longest:full,full"  -- 命令行补全模式
vim.opt.wildignore:append({      -- 忽略这些文件/目录
    "*/node_modules/*",
    "*.o",
    "*.obj",
    "*.pyc",
    "*.class",
    "*.jar",
})

-- 剪贴板设置
vim.opt.clipboard:append("unnamedplus")  -- 使用系统剪贴板（+ 寄存器）

-- 光标样式设置
vim.opt.guicursor =
    "n-v-c-sm-i-ci-ve-r-cr-o:ver25,t:ver25-blinkon400-blinkoff400-blinkwait300-Cursor"
    -- 普通/可视/命令等模式使用垂直光标；终端模式使用闪烁垂直光标

-- 代码折叠设置
vim.opt.foldenable = true                    -- 启用折叠
vim.opt.foldmethod = "expr"                  -- 使用表达式计算折叠
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"  -- 基于 Treesitter 语法折叠
vim.opt.foldcolumn = "0"                     -- 不显示折叠列
vim.opt.foldlevel = 99                       -- 默认展开所有折叠
vim.opt.foldlevelstart = 99                  -- 打开文件时默认展开所有折叠

-- 分屏行为设置
vim.opt.splitright = true        -- 垂直分屏时新窗口在右侧
vim.opt.splitbelow = true        -- 水平分屏时新窗口在下方

-- 终端与输入行为
vim.opt.virtualedit = "onemore"  -- 允许光标移动到行尾之后一个位置
vim.opt.backspace = "indent,eol,start"  -- 允许 Backspace 删除缩进、换行和插入点前内容
vim.opt.errorbells = false       -- 关闭错误提示音
vim.opt.visualbell = false       -- 关闭视觉提示铃

-- 内置 netrw 文件浏览器设置
vim.g.netrw_keepdir = 0              -- 切换目录时也改变工作目录
vim.g.netrw_localcopydircmd = "cp -r"  -- 本地复制目录使用的命令

-- LSP 诊断显示配置
vim.diagnostic.config({
    virtual_text = {                 -- 虚拟文本（行尾诊断信息）
        prefix = "",                 -- 不显示前缀符号
        spacing = 4,                 -- 与代码的间距
        source = true,               -- 显示诊断来源
        severity = {
            min = vim.diagnostic.severity.INFO,  -- 最低显示 INFO 级别
        },
    },
    signs = false,                   -- 不在符号列显示诊断符号
    update_in_insert = false,        -- 插入模式不更新诊断
    underline = true,                -- 使用下划线标记错误
    severity_sort = true,            -- 按严重程度排序
    float = {                        -- 浮动窗口诊断
        border = "rounded",          -- 圆角边框
        source = true,               -- 显示来源
        header = "",                 -- 不显示头部
        prefix = "",                 -- 不显示前缀
    },
})

-- 禁用不需要的内置插件，加快启动速度
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
    vim.g["loaded_" .. plugin] = 1   -- 标记为已加载，实际禁用
end

-- 自定义文件类型关联
vim.filetype.add({
    extension = {
        mjml = "html",               -- 将 .mjml 文件识别为 HTML
    },
})
