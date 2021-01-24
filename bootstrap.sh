#!/bin/bash

# install fonts
# Inconsolata
echo access http://levien.com/type/myfonts/inconsolata.html to install Inconsolata
# DejaVu Sans Mono
echo access https://dejavu-fonts.github.io/Download.html to install DejaVu Sans Mono

# install iTerm2
echo access https://www.iterm2.com/downloads.html to install iTerm2

# install necessary tools
sudo xcode-select --install

# git config
git config --global color.ui true
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.di difftool
git config --global alias.st "status --short --branch"
git config --global alias.last "log -1 HEAD"
git config --global push.default simple
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global difftool.prompt false
git config --global core.filemode false
git config --global core.excludesfile "${HOME}/.gitignore"

cat > "${HOME}/.gitignore" << EOF
*.py[co]
*.sw[op]
.DS_Store
.installed.cfg
bin/
develop-eggs/
*.egg-info/
eggs/
EOF

# install brew
# Ref. https://brew.sh/
if [[ ! -e /usr/local/bin/brew ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
	git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
	git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
	git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
	git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
	git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
fi
brew doctor
addpath=/usr/local/sbin
# install necessary packages
pkgs="direnv git-crypt gnupg upx wget"
if ! which python3; then
	pkgs="${pkgs} python"
else
	addpath="${addpath}:/Users/${USER}/Library/Python/$(python3 -V|grep -o '3.[0-9]')/bin"
fi
if ! which zsh; then
	pkgs="${pkgs} zsh"
fi
if [[ 1 -eq $(echo "$(vim --version|grep IMproved|grep -o '8.[0-9]') < 8.2" | bc) ]]; then
	pkgs="${pkgs} vim"
fi
brew install ${pkgs}

# switch to zsh
if [[ 0 -eq $(grep -c "$(which zsh)" /etc/shells) ]]; then
	sudo sed -i "" -e '/zsh/a\'$'\n'$(which zsh) /etc/shells
	chsh -s $(which zsh)
fi

# install oh-my-zsh
# Ref. https://github.com/robbyrussell/oh-my-zsh
if [[ ! -e "${HOME}/.oh-my-zsh" ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [[ 0 -eq $(grep -c "PYTHONDONTWRITEBYTECODE=x" "${HOME}/.zshrc") ]]; then
	cat >> "${HOME}/.zshrc" << EOF
# don't write .py[co] files on import
export PYTHONDONTWRITEBYTECODE=x
EOF
fi

if [[ 0 -eq $(grep -c "direnv hook zsh" "${HOME}/.zshrc") ]]; then
	cat >> "${HOME}/.zshrc" << EOF
# hook zsh 
# Ref. https://direnv.net/docs/hook.html
eval "\$(direnv hook zsh)"
EOF
fi

if [[ 0 -eq $(grep -c HOMEBREW_BOTTLE_DOMAIN "${HOME}/.zshrc") ]]; then
	cat >> "${HOME}/.zshrc" << EOF
# https://mirrors.tuna.tsinghua.edu.cn/help/homebrew-bottles/
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
EOF
fi

sed -i "" -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="gentoo"/' \
     -e 's/# DISABLE_AUTO_UPDATE="true"/DISABLE_AUTO_UPDATE="true"/' "${HOME}/.zshrc"

if [[ 0 -eq $(grep -c -E "^export PATH=" "${HOME}/.zshrc") ]]; then
	cat >> "${HOME}/.zshrc" << EOF
# additional PATH
export PATH=\${PATH}:${addpath}
EOF
fi

PYPI="https://pypi.douban.com/simple/"
PIP="${HOME}/Library/Application Support/pip/pip.conf"
mkdir -p "$(dirname "${PIP}")" 
cat << EOF > "${PIP}"
[global]
index-url = ${PYPI}
EOF

# install python packages
# https://pip.readthedocs.io/en/stable/user_guide/#configuration
if ! which pip3; then
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	sudo python get-pip.py -i "${PYPI}"
fi

pip3 install --user --ignore-installed flake8 virtualenv

# https://flake8.readthedocs.io/en/2.0/config.html
mkdir -p $(dirname "${HOME}/.config/flake8")
cat << EOF > "${HOME}/.config/flake8"
[flake8]
max-line-length = 160
EOF

# configure VIM
cat << EOF > "${HOME}/.vimrc"
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
    autocmd BufNewFile *.py 0r ${HOME}/.vim/template/py.tpl

    " python 展开 tab
    autocmd FileType python set tabstop=4 expandtab shiftwidth=4 softtabstop=4
    autocmd FileType python set ruler

    " F5 调试脚本
    autocmd FileType python map <F5> :!python3 %<CR>
    autocmd FileType lua map <F5> :!lua %<CR>
endif

if filereadable(expand("~/.vim/autoload/pathogen.vim"))
    " pathogen VIM 插件管理
    execute pathogen#infect()

    " NERDTree
    map <F3> :NERDTreeMirror<CR>
    map <F3> :NERDTreeToggle<CR>
endif
EOF

mkdir -p ${HOME}/.vim/autoload ${HOME}/.vim/bundle && curl -LSso ${HOME}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
pushd "${HOME}/.vim/bundle"
    git clone https://github.com/nvie/vim-flake8.git
    git clone https://github.com/scrooloose/nerdtree.git
    git clone https://github.com/fatih/vim-go.git
popd

mkdir -p "${HOME}/.vim/template"
cat << EOF > "${HOME}/.vim/template/py.tpl"
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
from __future__ import absolute_import

import logging

logging.basicConfig(level=logging.NOTSET,
                    format='[%(levelname)s]\t%(asctime)s\t%(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S %Z')
logger = logging.getLogger(__name__)

EOF

# SSH client
mkdir -p "${HOME}/.ssh/sockets"
cat << EOF > "${HOME}/.ssh/config"
# Ref. https://infosec.mozilla.org/guidelines/openssh#modern

HashKnownHosts yes
HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256
KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

ServerAliveInterval 120

Host *
    ControlMaster auto
    ControlPath ${HOME}/.ssh/sockets/%r@%h-%p
    ControlPersist 180

Host localhost
    HostName 127.0.0.1
    Port 22
    User ${USER}
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    IdentityFile ${HOME}/.ssh/id_ed25519

EOF
