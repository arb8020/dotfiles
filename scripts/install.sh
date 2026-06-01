#!/usr/bin/env sh
set -eu

repo_dir="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

mkdir -p "$HOME/.config"

if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  backup="$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
  mv "$HOME/.config/nvim" "$backup"
  printf 'Moved existing ~/.config/nvim to %s\n' "$backup"
fi

ln -sfn "$repo_dir/nvim/.config/nvim" "$HOME/.config/nvim"

if ! command -v nvim >/dev/null 2>&1; then
  printf 'nvim is not installed. Install Neovim, then run :PlugInstall.\n' >&2
fi

if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]; then
  curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

printf 'Installed nvim config symlink. Open nvim and run :PlugInstall.\n'
printf 'For the gd helper, source %s from your shell rc.\n' "$repo_dir/zsh/diff-review.zsh"
