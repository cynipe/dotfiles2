alias l='ls -lAh'
alias ll='ls -lh'

alias agrep="alias | grep '$1'"
alias hgrep="history | grep '$1'"
alias dush='du -sh'
alias df='df -h'
alias ssp='sshps-lpass'

# split ssh config files. see http://serverfault.com/questions/375525/can-you-have-more-than-one-ssh-config-file
alias compile-ssh-config="echo -n > ~/.ssh/config && find ~/.ssh/config.d -name '*.config' -print | sort | xargs cat >> ~/.ssh/config"
alias ssh='compile-ssh-config && ssh'

alias peco="peco --rcfile=~/.peco.json"

[[ $OSTYPE == 'darwin'* ]] && {
  alias tmux="env TERM=screen-256color tmuxx"
  alias vim='env TERM=xterm-256color /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias gvim='/Applications/MacVim.app/Contents/MacOS/mvim "$@"'
  alias gvimdiff='/Applications/MacVim.app/Contents/MacOS/mvimdiff "$@"'
}
export EDITOR='env TERM=xterm-256color /Applications/MacVim.app/Contents/MacOS/Vim'
