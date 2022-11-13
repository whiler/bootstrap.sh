#!/bin/bash

gitupdate() {
	pushd "$1" || return
	if [[ -n "$(git remote)" ]]; then
		git pull
	fi
	popd || return
}

brew leaves
brew update
brew upgrade
brew cleanup -s
brew autoremove
brew doctor
brew missing

if [[ -e "${HOME}/.oh-my-zsh" ]]; then
	gitupdate "${HOME}/.oh-my-zsh" &
fi

if [[ -e "${HOME}/.vim/bundle" ]]; then
	for plugin in "${HOME}/.vim/bundle/"* ; do
		gitupdate "${plugin}" &
	done
fi

wait
