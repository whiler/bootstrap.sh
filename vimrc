" VIMRC
" last modified 2015Äê 8ÔÂ17ÈÕ ÐÇÆÚÒ» 21Ê±04·Ö15Ãë CST
"

" ²»¼æÈÝÄ£Ê½
set nocompatible

" ÔØÈëÎÄ¼þÀàÐÍ²å¼þ
filetype plugin on

" ²»×Ô¶¯»»ÐÐ
set nowrap

" µ±ÎÄ¼þ´ÓÍâ²¿±»¸Ä¶¯Ê±×Ô¶¯ÔØÈë
set autoread

" ´øÓÐÈçÏÂ·ûºÅµÄµ¥´Ê²»Òª±»»»ÐÐ·Ö¸î
set iskeyword+=_,$,@,%,#,- 

" ²»±¸·ÝÎÄ¼þ
set nobackup

" ×Ö·û¼ä²åÈëµÄÏñËØÐÐÊýÄ¿
set linespace=0

" ÔÚ´¦ÀíÎ´±£´æ»òÖ»¶ÁÎÄ¼þµÄÊ±ºò£¬µ¯³öÈ·ÈÏ
set confirm

" ²»Éè¶¨´ËÏîµÄ»°ÔÚ²åÈë×´Ì¬ÎÞ·¨ÓÃÍË¸ñ¼üºÍ Delete ¼üÉ¾³ý»Ø³µ·û
set backspace=indent,eol,start

" Éè¶¨ÎÄ¼þä¯ÀÀÆ÷Ä¿Â¼Îªµ±Ç°Ä¿Â¼
set bsdir=buffer

" ×Ô¶¯ÇÐ»»Ä¿Â¼
set autochdir

if has("autocmd")
    " ¼Ç×¡ÉÏÒ»´Î´ò¿ªµÄÎ»ÖÃ
    autocmd BufReadPost * if line(" '\" ") > 0 && line(" '\" ") <= line(" $") | exe " normal g'\" "  | endif
endif

" ²»·¢³öÌÖÑáµÄµÎµÎÉù
set noerrorbells

" ÓëÏµÍ³¹²Ïí¼ôÌù°å
set clipboard+=unnamed


" --------------------------------------------------------------
" ×Ô¶¯Ëõ½ø
set autoindent
set smartindent

" CÓïÑÔÑùÊ½µÄËõ½ø
set cindent

" Ëõ½ø4¸ö¿Õ¸ñ
set tabstop=4
set softtabstop=4
set shiftwidth=4

" ×Ô¶¯¸ñÊ½»¯
set formatoptions=tcrqn

" Õì²âÎÄ¼þÀàÐÍ
filetype on

" ÎªÌØ¶¨ÎÄ¼þÀàÐÍÔØÈëÏà¹ØËõ½øÎÄ¼þ
filetype indent on


" --------------------------------------------------------------
" Óï·¨¸ßÁÁ
syntax on

" ¸ßÁÁËÑË÷
set hlsearch
set incsearch

" ¸ßÁÁÏÔÊ¾Æ¥ÅäµÄÀ¨ºÅ
set showmatch


" --------------------------------------------------------------
" ÓïÑÔÉèÖÃ
set langmenu=zh_CN.UTF-8
set helplang=cn

" VIMÄÚ²¿±àÂë
set encoding=utf-8

" VIMÔÚÓëÆÁÄ»/¼üÅÌ½»»¥Ê±Ê¹ÓÃµÄ±àÂë
set termencoding=utf-8

" VIMµ±Ç°±à¼­µÄÎÄ¼þÔÚ´æ´¢Ê±µÄ±àÂë
set fileencoding=utf-8

" VIM´ò¿ªÎÄ¼þÊ±µÄ³¢ÊÔÊ¹ÓÃµÄ±àÂë
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-kr,latin1

" ¶Ô¡°²»Ã÷¿í¶È¡±×Ö·ûµÄ´¦Àí·½Ê½
set ambiwidth=double

" Console ÏÔÊ¾ÖÐÎÄ
language messages zh_CN.UTF-8


" --------------------------------------------------------------
" ¿ªÆôÕÛµþ
set foldenable
" ÉèÖÃËõ½øÕÛµþ
set foldmethod=marker
" ÉèÖÃÕÛµþÇøÓòµÄ¿í¶È
set foldcolumn=0
" ÉèÖÃÕÛµþ²ãÊýÎª
setlocal foldlevel=0


" --------------------------------------------------------------
if has("autocmd")

    " Ä£°åÎÄ¼þ
    autocmd BufNewFile *.py 0r $HOME/.vim/template/py.tpl

    " Python Õ¹¿ªTab
    autocmd FileType python set tabstop=4 expandtab shiftwidth=4 softtabstop=4
    autocmd FileType python set ruler

    " F5µ÷ÊÔPython
    autocmd FileType python map <F5> :!python %<CR>
endif


" --------------------------------------------------------------
" ÆôÓÃvim-pathogen²å¼þ
if filereadable(expand("~/.vim/autoload/pathogen.vim"))
    execute pathogen#infect()

" ÉèÖÃNERDTree
    map <F3> :NERDTreeMirror<CR>
    map <F3> :NERDTreeToggle<CR>
endif
