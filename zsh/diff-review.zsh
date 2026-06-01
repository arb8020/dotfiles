# Open a git diff in Neovim with the diff-review keymaps enabled.
#
# Usage:
#   gd
#   gd HEAD~3..HEAD
#   gd 70724f5^..70724f5
gd() {
  local range="${1:-HEAD}"
  git diff "$range" | nvim -c "set ft=diff" -c "let b:diff_range='$range'" -
}
