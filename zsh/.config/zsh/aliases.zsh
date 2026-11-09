# ALIASES

#EZA
alias ls='eza --icons' #Better ls
alias ll='eza -lh --icons' #Detailed listing
alias la='eza -lah --icons' #Same + hidden files
alias tree='eza --tree --icons' #Tree view
compdef eza=ls #Reuse ls completions for eza

#BAT
alias cat='bat'

#Core Utils
alias grep='rg --color=auto' #Ripgrep
alias diff='diff --color=auto'
alias df='df -h'

#Navigation
alias -- -='cd -' #cd jumps to prevous directory

#Editor
alias vim='nvim'

#Git
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

#Projects
alias ledger='cd ~/projects/ledger2 && source .venv/bin/activate && python3 main.py & disown; deactivate; cd ~'
