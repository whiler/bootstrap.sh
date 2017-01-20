#!/bin/bash

PYPI="https://pypi.douban.com/simple/"

# install fonts
# Inconsolata
# http://levien.com/type/myfonts/inconsolata.html
# DejaVu Sans Mono
# http://dejavu-fonts.org/wiki/Download

# install iTerm2
# https://www.iterm2.com/downloads.html

# change shell
sudo cash -s /bin/zsh

# install necessary tools
sudo xcode-select --install

# git config
git config --global color.ui true
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.di difftool
git config --global alias.st status 
git config --global alias.last 'log -1 HEAD'
git config --global push.default simple
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
git config --global difftool.prompt false
git config --global core.filemode false
git config --global core.excludesfile '${HOME}/.gitignore'

git config --global user.name "whiler"
git config --global user.email "wenwu500@qq.com"

cp gitignore "${HOME}/.gitignore"

# install oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i "" \
    -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="gentoo"/' \
    -e 's/plugins=(git)/plugins=(git osx)/' \
    -e 's/# DISABLE_AUTO_UPDATE="true"/DISABLE_AUTO_UPDATE="true"/' "${HOME}/.zshrc"

# install brew
# https://github.com/Homebrew/homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "export HOMEBREW_GITHUB_API_TOKEN=8ad8a3877aea831d8834325925ef6c9810446660" >> "${HOME}/.zshrc"
brew doctor

# install python packages
# https://pip.readthedocs.io/en/stable/user_guide/#configuration
sudo python get-pip.py -i "${PYPI}"
mkdir -p $(dirname ${HOME}/Library/Application Support/pip/pip.conf) 
cat << EOF > ${HOME}/Library/Application Support/pip/pip.conf
[global]
index-url = ${PYPI}
EOF

# Error six 1.4.1
sudo pip install flake8 virtualenvwrapper --ignore-installed six
cat << EOF >> ${HOME}/.zshrc
# https://virtualenvwrapper.readthedocs.io/en/latest/
export WORKON_HOME=\${HOME}/.venv
source /usr/local/bin/virtualenvwrapper.sh
EOF
# https://flake8.readthedocs.io/en/2.0/config.html
mkdir -p $(dirname ${HOME}/.config/flake8)
cat << EOF > ${HOME}/.config/flake8
[flake8]
max-line-length = 160
EOF

# configure VIM
cp vimrc "${HOME}/.vimrc"
mkdir -p "${HOME}/.vim/autoload" "${HOME}/.vim/bundle"
curl -LSso "${HOME}/.vim/autoload/pathogen.vim" "https://tpo.pe/pathogen.vim"
pushd "${HOME}/.vim/bundle"
	git clone https://github.com/nvie/vim-flake8.git
	git clone https://github.com/scrooloose/nerdtree.git
popd
mkdir -p "${HOME}/.vim/template"
cp py.tpl "${HOME}/.vim/template"

# SSH
ssh-keygen
