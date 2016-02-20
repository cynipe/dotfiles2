EXT_PATH=
EXT_MANPATH=
[[ $OSTYPE == 'darwin'* ]] && {
    EXT_PATH=$(brew --prefix coreutils)/libexec/gnubin
    EXT_MANPATH=$(brew --prefix coreutils)/libexec/gnuman
}
export PATH="$HOME/bin:${EXT_PATH}:${PATH}"
export MANPATH="${EXT_MANPATH}:${MANPATH}"
# PATHの重複部を削除 see http://blog.n-z.jp/blog/2013-12-12-zsh-cleanup-path.html
# 1. NULL_GLOB の N を使って存在しないディレクトリを除外
# 2. -/ を使ってシンボリックリンクの場合のリンク先もチェックした上でディレクトリのみ残す
# 3. ^W で world-writable という実行ファイルのパスとしては危険なパーミッションになっているディレクトリを除外
# 4. ${^spec} で RC_EXPAND_PARAM を有効にしてパスすべてに適用
typeset -U path PATH
typeset -U manpath MANPATH
path=(${^path}(N-/^W))
manpath=(${^manpath}(N-/^W))

export LANG='en_US.UTF-8'
export TERM='xterm-256color'
export DOTDIR=$(cd -P "$( dirname "$(readlink ${(%):-%N})" )" && pwd )

setopt no_beep

# History
HISTFILE=~/.zsh_history
SIZEHIST=100000
SAVEHIST=500000
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt extended_history
setopt hist_expand
setopt share_history
setopt inc_append_history

[[ -f /opt/boxen/env.sh ]] && source /opt/boxen/env.sh
[[ -f ~/bin/direnv ]]      && eval "$(direnv hook zsh)"
[[ -f ~/.zshrc.local ]]    && source ~/.zshrc.local

ZPLUG_EXTERNAL=~/.zplugrc
source ~/.zplug/zplug
zplug check || zplug install
zplug load

zplug check "mollifier/anyframe" && {
    bindkey '^r' anyframe-widget-put-history
    bindkey '^]' anyframe-widget-insert-ghq

    bindkey '^f'  anyframe-widget-insert-filename
    bindkey '^b'  anyframe-widget-insert-git-branch
}
