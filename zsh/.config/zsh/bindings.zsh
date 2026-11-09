#KEYBINDINGS

# Cursor shape per VI mode
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# Disbale command mode line highlight
ZVM_VI_HIGHLIGHT_BACKGROUND=none
ZVM_VI_HIGHLIGHT_FOREGROUND=none
ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

zum_after_init() {
  bindkey '^[[1;5C' forward-word #CTRL-R
  bindkey '^[[1;5D' backward-word #CTRL-L

  bindkey '^F' _fzf_file_no_hidden #CTRL-F

  bindkey '^\' autosuggest-toggle #CTRL-\

  bindkey '^[[A' history-substring-search-up #U
  bindkey '^[[B' history-substring-search-down #D
}
