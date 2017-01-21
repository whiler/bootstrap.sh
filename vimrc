" 不兼容模式
set nocompatible

" 载入文件类型插件
filetype plugin on

" 不自动换行
set nowrap

" 当文件从外部修改时，自动载入
set autoread

" 不分割带有如下符号的单词
set iskeyword+=_,$,@,%,#,- 

" 不备份文件
set nobackup

" 行间距
set linespace=0

" 处理未保存或者只读文件时，要求确认
set confirm

" 在插入状态启用退格删除
set backspace=indent,eol,start

" 文件路径为当前路径
set bsdir=buffer

" 自动切换目录
set autochdir

" 不发出滴滴声
set noerrorbells

" 共享系统粘贴板
set clipboard+=unnamed

" 自动缩进
set autoindent
" 智能缩进
set smartindent
" C 语言样式缩进
set cindent

" 缩进 4  个空格
set tabstop=4
set softtabstop=4
set shiftwidth=4

" 自动格式化
set formatoptions=tcrqn

" 检测文件类型
filetype on

" 语法高亮
syntax on

" 高亮搜索关键字
set hlsearch
set incsearch

" 高亮匹配的括号
set showmatch

" 语言
set langmenu=zh_CN.UTF-8
set helplang=cn

" VIM 内部编码
set encoding=utf-8

" 终端交互编码
set termencoding=utf-8

" 文件保存时的编码
set fileencoding=utf-8

" 打开文件时尝试的编码
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-kr,latin1

" 非 ASCII 字符的宽度
set ambiwidth=double

" 显示中文
language messages zh_CN.UTF-8

" 开启折叠
set foldenable

" 按标记折叠
set foldmethod=marker

" 折叠宽度
set foldcolumn=0
" 折叠层数
setlocal foldlevel=0

if has("autocmd")
    " 记住上次打开的位置
    autocmd BufReadPost * if line(" '\" ") > 0 && line(" '\" ") <= line(" $") | exe " normal g'\" "  | endif

    " 使用模版创建 python 文件
    autocmd BufNewFile *.py 0r $HOME/.vim/template/py.tpl

    " python 展开 tab
    autocmd FileType python set tabstop=4 expandtab shiftwidth=4 softtabstop=4
    autocmd FileType python set ruler

    " F5 调试脚本
    autocmd FileType python map <F5> :!python %<CR>
    autocmd FileType lua map <F5> :!lua %<CR>
endif

if filereadable(expand("~/.vim/autoload/pathogen.vim"))
    " pathogen VIM 插件管理
    execute pathogen#infect()

    " NERDTree
    map <F3> :NERDTreeMirror<CR>
    map <F3> :NERDTreeToggle<CR>
endif
