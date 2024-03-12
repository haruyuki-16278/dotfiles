#!/bin/sh

dir="$(dirname "$0")"
cd "$dir"

echo "$PWD"

ln -s $dir/.zshrc ~/.zshrc
ln -s $dir/.vimrc ~/.vimrc
ln -s $dir/.tmux.conf ~/.tmux.conf
