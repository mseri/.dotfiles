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
    echo "Please execute bootstrap.sh from .dotfiles directory in $HOME"
    exit 1
fi

# Check we're up to date
git pull

# Add links to these files
install_dotfile "$HOME/.dotfiles/git/gitconfig" "$HOME/.gitconfig"
install_dotfile "$HOME/.dotfiles/git/gitignore_global" "$HOME/.gitignore_global"

#install_dotfile "$HOME/.dotfiles/i3/config" "$HOME/.config/i3/config"

install_dotfile "$HOME/.dotfiles/helix/config.toml" "$HOME/.config/helix/config.toml"
install_dotfile "$HOME/.dotfiles/helix/languages.toml" "$HOME/.config/helix/languages.toml"

install_dotfile "$HOME/.dotfiles/nvim/init.lua" "$HOME/.config/nvim/init.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/config/lazy.lua" "$HOME/.config/nvim/lua/config/lazy.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/plugins/cmp.lua" "$HOME/.config/nvim/lua/plugins/cmp.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/plugins/colorscheme.lua" "$HOME/.config/nvim/lua/plugins/colorscheme.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/plugins/copilot.lua" "$HOME/.config/nvim/lua/plugins/copilot.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/plugins/lspconfig.lua" "$HOME/.config/nvim/lua/plugins/lspconfig.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/plugins/treesitter.lua" "$HOME/.config/nvim/lua/plugins/treesitter.lua"
install_dotfile "$HOME/.dotfiles/nvim/lua/plugins/vimtex.lua" "$HOME/.config/nvim/lua/plugins/vimtex.lua"

install_dotfile "$HOME/.dotfiles/utoprc" "$HOME/.utoprc"
install_dotfile "$HOME/.dotfiles/ocamlinit" "$HOME/.ocamlinit"

install_dotfile "$HOME/.dotfiles/latexmkrc" "$HOME/.latexmkrc"

install_dotfile "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"

# OS specific config
case "$OSTYPE" in
    darwin*)
        ;;
    linux*)
        ;;
esac

if which llm > /dev/null; then
  install_dotfile $HOME/.dotfiles/tools/q $HOME/.local/bin/q
fi

if [ ! -d "$HOME/.powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
fi

if [ ! -d "$HOME/.fsd" ]; then
    git clone https://github.com/zdharma/fast-syntax-highlighting ~/.fsd
fi

if [ ! -d "$HOME/.local/share/toolgit" ]; then
  # Some git utils
  git clone https://github.com/ahmetsait/toolgit  $HOME/.local/share/toolgit
  ln -s $HOME/.local/share/toolgit/git-* $HOME/.local/bin
  git config set --append --global include.path $HOME/.local/share/toolgit/aliases.ini
fi

echo "Remember to restart the shell to refresh zsh configuration"
cd "$HOME"
echo "Initialisation complete!"
