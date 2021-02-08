#!/bin/bash

gitupdate() {
    pushd "$1"
        if [[ ! -z "$(git remote)" ]]; then
            git checkout master
            git pull origin master
        fi
    popd
}

brew update
brew upgrade
brew cleanup -s
brew doctor
brew missing

python3 -m pip freeze | grep 'file://' | cut -d ' ' -f 1 | sort -u > /tmp/e.txt
python3 -m pipdeptree | grep -o -E '^\w[^=]+' > /tmp/r.txt && \
	echo "wheel" >> /tmp/r.txt && \
	echo "pip" >> /tmp/r.txt && \
	echo "setuptools" >> /tmp/r.txt && \
	sort -u < /tmp/r.txt > /tmp/rr.txt && \
	sed -i '' -e 's/prompt-toolkit/prompt-toolkit<2.1.0,>=2.0.0/' /tmp/rr.txt
comm -23 /tmp/rr.txt /tmp/e.txt > /tmp/pkgs.txt
python3 -m pip install -U -r /tmp/pkgs.txt
rm /tmp/pkgs.txt /tmp/rr.txt /tmp/e.txt /tmp/r.txt

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
