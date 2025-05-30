let mapleader = " "  " 将 leader 键设置为空格
" set list  " 显示不可见符号
" set listchars=tab:>-,trail:·,eol:$,space:·,extends:>,precedes:<
set wrap           " 启用自动换行
set linebreak      " 在单词边界处换行
set nolist        " 关闭 list 模式以避免干扰 linebreak
set showbreak=↪   " 显示换行符标记（可选）
set breakindent   " 保持换行后的缩进（可选）
set clipboard+=unnamedplus  " 将系统剪贴板设置为默认寄存器
set mouse=a " 启用鼠标
set lazyredraw  " 关闭显示重绘
set ttyfast  " 提高性能的其他选项
set nocompatible " 关闭 vi 兼容模式
syntax on " 自动语法高亮
set number " 显示行号
set virtualedit=onemore " 允许光标移动到最后一个字符之后(非插入模式)
set cursorline " 突出显示当前行
set scroll=10  " 设置 Ctrl-U 和 Ctrl-D 滚动的行数
set scrolljump=1  " 当光标移出屏幕时滚动的行数
set scrolloff=8  " 保持光标上下文可见行数，让滚动更平滑
set ruler " 打开状态栏标尺
set nobackup " 不创建备份文件
set noswapfile " 不创建交换文件
set nowritebackup " 不允许其他程序同时编辑同一文件
set shiftwidth=4 " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4 " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4 " 设定 tab 长度为 4
set nobackup " 覆盖文件时不备份
set autochdir " 自动切换当前目录为当前文件所在的目录
set backupcopy=yes " 设置备份时的行为为覆盖
set ignorecase smartcase " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set nowrapscan " 禁止在搜索到文件两端时重新搜索
set incsearch " 输入搜索内容时就显示搜索结果
set hlsearch " 搜索时高亮显示被找到的文本
set noerrorbells " 关闭错误信息响铃
set novisualbell " 关闭使用可视响铃代替呼叫
set t_vb= " 置空错误铃声的终端代码
" set showmatch " 插入括号时，短暂地跳转到匹配的对应括号
" set matchtime=2 " 短暂跳转到匹配括号的时间
set magic " 设置魔术
set hidden " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
set guioptions-=T " 隐藏工具栏
set guioptions-=m " 隐藏菜单栏
set smartindent " 开启新行时使用智能自动缩进
set backspace=indent,eol,start  " 不设定在插入状态无法用退格键和 Delete 键删除回车符
set cmdheight=1 " 设定命令行的行数为 1
set laststatus=2 " 显示状态栏 (默认值为 1, 无法显示状态栏)
set foldenable " 开始折叠
set foldmethod=syntax " 设置语法折叠
set foldcolumn=0 " 设置折叠区域的宽度
setlocal foldlevel=1 " 设置折叠层数为
set viminfo="NONE"  " 不生产viminfo文件
" set foldclose=all " 设置为自动关闭折叠 
" nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>   " 用空格键来开关折叠

highlight Comment cterm=italic gui=italic  " 设置注释为斜体
highlight LineNr ctermfg=DarkGrey guifg=#666666   " 设置普通行号的颜色
highlight CursorLineNr ctermfg=DarkRed guifg=#F98A4E   " 设置当前行号的颜色

" 离开插入模式时自动关闭 paste 模式
augroup auto_nopaste
  autocmd!
  autocmd InsertLeave * set nopaste
augroup END

" 保存时自动删除空行中的空格字符
augroup RemoveTrailingSpaces
    autocmd!
    autocmd BufWritePre * let save_cursor = getpos(".") | %s/^\s\+$//e | call setpos('.', save_cursor)
augroup END

" 定义获取当前模式的函数
function! GetMode()
    let l:mode = mode()
    if l:mode ==# 'n'
        return 'NORMAL'
    elseif l:mode ==# 'i'
        return 'INSERT'
    elseif l:mode ==# 'R'
        return 'REPLACE'
    elseif l:mode ==# 'v'
        return 'VISUAL'
    elseif l:mode ==# 'V'
        return 'V-LINE'
    elseif l:mode ==# "\<C-V>"
        return 'V-BLOCK'
    elseif l:mode ==# 'c'
        return 'COMMAND'
    else
        return 'OTHER'
    endif
endfunction

" 定义文件格式显示转换函数
function! GetFileFormat()
    let l:ff = &fileformat
    if l:ff ==# 'unix'
        return 'LF'
    elseif l:ff ==# 'dos'
        return 'CRLF'
    elseif l:ff ==# 'mac'
        return 'CR'
    endif
    return l:ff
endfunction

" 设置状态栏显示信息，调用 GetMode() 函数
set statusline=%{GetMode()}%M%*%R%=\ %f%=\ %0(%{GetFileFormat()}\ %{&encoding}\ %c:%l%)

" 注释快捷键  支持普通模式和插入模式的, ctrl -
nnoremap <C-_> :call ToggleComment()<CR>
vnoremap <C-_> :call ToggleComment()<CR>
inoremap <C-_> <ESC>:call ToggleComment()<CR>i
 
func! ToggleComment()
    let l:line = getline(".")
    if l:line =~ '^\s*#' || l:line =~ '^\s*\/\/' || l:line =~ '^\s*"'
        if &filetype == 'python' || &filetype == 'shell'
            execute "normal! ^x"
        elseif &filetype == 'vim'
            execute "normal! ^x"
        else
            execute "normal! ^2x"
        endif
    else
        if &filetype == 'python' || &filetype == 'shell'
            execute "normal! I# "
        elseif &filetype == 'vim'
            execute "normal! I\" "
        else
            execute "normal! I// "
        endif
    endif
endfunc

" 向下粘贴当前行, 类似于jetbrains
nnoremap <C-d> "+yy"+p
inoremap <C-d> <Esc>"+yy"+p<i

" 普通模式下的全选
nnoremap <C-a> ggVG
" 插入模式和可视模式下的全选
inoremap <C-a> <Esc>ggVG
vnoremap <C-a> <Esc>ggVG

" 选中状态(即可视模式)下 Ctrl+c 复制
vmap <C-c> "+y

" 可视模式下的缩进，保持选中状态
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" 普通模式下的缩进
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_

"窗口分割时,进行切换的按键热键需要连接两次,比如从下方窗口移动
"光标到上方窗口,需要<c-w><c-w>k,非常麻烦,现在重映射为<c-k>,切换的
"时候会变得非常方便.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"一些不错的映射转换语法（如果在一个文件中混合了不同语言时有用）
nnoremap <leader>1 :set filetype=xhtml<CR>
nnoremap <leader>2 :set filetype=css<CR>
nnoremap <leader>3 :set filetype=javascript<CR>
nnoremap <leader>4 :set filetype=php<CR>

" set fileformats=unix,dos,mac
" nmap <leader>fd :se fileformat=dos<CR>
" nmap <leader>fu :se fileformat=unix<CR>

" 让 Tohtml 产生有 CSS 语法的 html
" syntax/2html.vim，可以用:runtime! syntax/2html.vim
let html_use_css=1

" Python 文件的一般设置，比如不要 tab 等
augroup python_settings
    autocmd!
    " Python 缩进设置
    autocmd FileType python setlocal tabstop=4
    autocmd FileType python setlocal shiftwidth=4
    autocmd FileType python setlocal expandtab
    " Python 运行快捷键
    autocmd FileType python nnoremap <F12> :!python %<CR>
augroup END

" 打开javascript折叠
let b:javascript_fold=1
" 打开javascript对dom、html和css的支持
let javascript_enable_domhtmlcss=1
" 设置字典 ~/.vim/dict/文件的路径
augroup file_dictionaries
    autocmd!
    autocmd FileType javascript setlocal dictionary=$VIMFILES/dict/javascript.dict
    autocmd FileType css setlocal dictionary=$VIMFILES/dict/css.dict
    autocmd FileType php setlocal dictionary=$VIMFILES/dict/php.dict
augroup END

highlight StatusLine cterm=bold ctermfg=231 ctermbg=NONE guifg=#ffffff guibg=NONE
