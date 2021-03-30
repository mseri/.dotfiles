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
#install_dotfile "$HOME/.dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
install_dotfile "$HOME/.dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"
#install_dotfile "$HOME/.dotfiles/Code/settings.json" "$HOME/.config/Code/User/settings.json"
#install_dotfile "$HOME/.dotfiles/terminator/config" "$HOME/.config/terminator/config"
#install_dotfile "$HOME/.dotfiles/alacritty/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
#install_dotfile "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
install_dotfile "$HOME/.dotfiles/utoprc" "$HOME/.utoprc"
install_dotfile "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"
install_dotfile "$HOME/.dotfiles/zsh/custom.zsh" "$HOME/.custom.zsh"

# OS specific config
case "$OSTYPE" in
    darwin*)
        ;;
    linux*)
        ;;
esac

if [ ! -d "$HOME/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi

#if [ ! -d "$HOME/.emacs.d" ]; then
#    git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
#fi
#install_dotfile "$HOME/.dotfiles/spacemacs/spacemacs" "$HOME/.spacemacs"

echo "Remember to run source ~/.zshrc to refresh zsh configuration"
cd "$HOME"
echo "Initalization complete!"
