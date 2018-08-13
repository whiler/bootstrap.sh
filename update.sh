#!/bin/bash

gitupdate() {
	pushd "$1"
		if [[ ! -z "$(git remote)" ]]; then
			git checkout master
			git pull origin master
		fi
	popd
}

brew upgrade

(pip3 freeze | cut -d= -f1 > /tmp/r.txt && \
 echo "wheel" >> /tmp/r.txt && \
 echo "pip" >> /tmp/r.txt && \
 echo "setuptools" >> /tmp/r.txt && \
 sed -i '' -e 's/prompt-toolkit/prompt-toolkit<2.0.0,>=1.0.15/' /tmp/r.txt && \
 pip3 install -U -r /tmp/r.txt && \
 rm /tmp/r.txt)&
 
if [[ -e "${HOME}/.oh-my-zsh" ]]; then
	gitupdate "${HOME}/.oh-my-zsh" &
fi

if [[ -e "${HOME}/.vim/bundle" ]]; then
	for plugin in $(ls "${HOME}/.vim/bundle");
	do
		gitupdate "${HOME}/.vim/bundle/${plugin}" &
	done
fi

wait
