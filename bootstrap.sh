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
#install_dotfile "$HOME/.dotfiles/i3/config" "$HOME/.config/i3/config"
install_dotfile "$HOME/.dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"
install_dotfile "$HOME/.dotfiles/utoprc" "$HOME/.utoprc"
install_dotfile "$HOME/.dotfiles/ocamlinit" "$HOME/.ocamlinit"
install_dotfile "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"

# OS specific config
case "$OSTYPE" in
    darwin*)
        ;;
    linux*)
        ;;
esac

if [ ! -d "$HOME/.powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
fi

if [ ! -d "$HOME/.fsd" ]; then
    git clone https://github.com/zdharma/fast-syntax-highlighting ~/.fsd
fi

echo "Remember to restart the shell to refresh zsh configuration"
cd "$HOME"
echo "Initalization complete!"
