# dotfiles

Shareable dotfiles focused on a Neovim git diff review workflow.

## Install

```sh
git clone https://github.com/arb8020/dotfiles.git ~/dotfiles
~/dotfiles/scripts/install.sh
```

Then open Neovim and run:

```vim
:PlugInstall
```

To enable the `gd` shell helper, add this to `~/.zshrc`:

```sh
source "$HOME/dotfiles/zsh/diff-review.zsh"
```

## Diff Review Workflow

Open a diff:

```sh
gd
gd HEAD~3..HEAD
gd main..HEAD
```

Inside the diff buffer:

- `go`: show the old version of the file under the cursor.
- `gn`: show the new version of the file under the cursor.
- `gd`: return from file view back to the diff.
- `za`, `zo`, `zc`: toggle/open/close folds.

Git hunk navigation in normal files:

- `]c` / `[c`: next/previous hunk.
- `<leader>hp`: preview hunk.
- `<leader>hs`: stage hunk.
- `<leader>hr`: reset hunk.

Git UI:

- `<leader>g`: open Neogit.
- `:DiffviewOpen`: open Diffview.
- `:DiffviewFileHistory`: inspect file history.

Search:

- `<leader>f`: find files.
- `<leader>/`: ripgrep.
- `<leader>b`: buffers.

## Requirements

- Neovim 0.10+
- git
- curl
- ripgrep for `<leader>/`
- fzf for shell-side fuzzy workflows

The config uses vim-plug and installs plugins on `:PlugInstall`.
