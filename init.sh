#!/bin/sh

# ディレクトリ名を取得
dir="$(dirname "$0")"
cd "$dir"

# リンク作成先を確認
echo "make links to $PWD . ok? (y/N)"
read ok
if [ "$ok" = "y" ]; then
    # リンク作成
    echo "link .zshrc"
    ln -s $PWD/.zshrc ~/.zshrc
    echo "link .vimrc"
    ln -s $PWD/.vimrc ~/.vimrc
    echo "link .tmux.conf"
    ln -s $PWD/.tmux.conf ~/.tmux.conf

    echo "done!"
else
    # キャンセルされたらエラーコードありで終了
    echo "cancel."
    exit 1
fi
