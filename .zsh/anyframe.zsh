function anyframe-widget-insert-ghq() {
  anyframe-source-ghq-repository \
    | anyframe-selector-auto \
    | anyframe-action-insert
}
zle -N anyframe-widget-insert-ghq
