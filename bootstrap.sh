#!/bin/bash

# install_dotfile (file, dst)
# --
# If the destination already exists then overwrite it iff it is a symlink,
# otherwise leave it alone

set +ev

install_dotfile () {
    if [ ! -d $(dirname $2) ]; then
        echo "Skipping $2: destination directory does not exist"
        return
    fi

    if [ -e $2 -a ! -h $2 ]; then
        echo "Skipping $2: installing would overwrite non-symlink"
        return
    fi

    echo -n "Linking $2..."
    ln -sf $1 $2
    echo "done"
}

if [ "$PWD" != "$HOME/.dotfiles" ]; then
    echo "Please execute bootstap.sh from .dotfiles directory in $HOME"
    exit 1
fi

# Check we're up to date
git pull

# Add links to these files
install_dotfile "$HOME/.dotfiles/git/gitconfig" "$HOME/.gitconfig"
install_dotfile "$HOME/.dotfiles/git/gitignore_global" "$HOME/.gitignore_global"
install_dotfile "$HOME/.dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
install_dotfile "$HOME/.dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"
install_dotfile "$HOME/.dotfiles/terminator/config" "$HOME/.config/terminator/config"
install_dotfile "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
install_dotfile "$HOME/.dotfiles/utoprc" "$HOME/.utoprc"
install_dotfile "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"

# OS specific config
case "$OSTYPE" in
    darwin*)
        ;;
    linux*)
        ;;
esac

if [ ! -d "$HOME/.slimzsh" ]; then
    git clone --recursive https://github.com/changs/slimzsh.git ~/.slimzsh
fi
install_dotfile "$HOME/.dotfiles/zsh/aliases.zsh.local" "$HOME/.slimzsh/aliases.zsh.local"

echo "Remember to run source ~/.zshrc to refresh zsh configuration"
cd "$HOME"
echo "Initalization complete!"
