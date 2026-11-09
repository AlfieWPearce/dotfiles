# FZF

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'

# Ctrl-T - use fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Compact UI
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"

# Ctrl-F - file pick
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf) && LBUFFER="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
