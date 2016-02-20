if neobundle#tap('unite.vim') "{{{
  let g:unite_enable_start_insert = 1
  let g:unite_enable_smart_case = 1

  nnoremap [unite] <Nop>
  xnoremap [unite] <Nop>
  nmap f [unite]
  xmap f [unite]

  " reset unite cache
  nnoremap [unite]q <Plug>(unite_restart)
  " list unite sources
  nnoremap [unite]s :<C-u>Unite -no-split -start-insert source<CR>

  nnoremap [unite]f
        \ :<C-u>Unite file_rec/git:--cached:--others:--exclude-standard -buffer-name=git-file-buffer
        \ -no-split -start-insert<CR>
  nnoremap [unite]F
        \ :<C-u>Unite file_rec/async -buffer-name=all-file-buffer
        \ -no-split -start-insert<CR>
  nnoremap [unite]b
        \ :<C-u>Unite buffer -buffer-name=buffer-buffer
        \ -no-split -no-empty -start-insert<CR>
  nnoremap [unite]g
        \ :<C-u>Unite grep:. -buffer-name=grep-buffer
        \ -no-split -start-insert<CR>
  nnoremap [unite]w
        \ :<C-u>Unite grep:. -buffer-name=grep-buffer
        \ -no-split -start-insert<CR><C-R><C-W><CR>
  nnoremap [unite]r
        \ :<C-u>UniteResume -no-split grep-buffer<CR>
  nnoremap [unite]o
        \ :<C-u>Unite outline
        \ -no-split -start-insert<CR>

  let neobundle#hooks.on_source ='~/.vim/plugins/unite.rc.vim'
  call neobundle#untap()
endif "}}}

if neobundle#tap('neocomplete.vim') && has('lua') "{{{
  let g:acp_enableAtStartup                           = 0
  let g:neocomplete#enable_at_startup                 = 1
  let neobundle#hooks.on_source = '~/.vim/plugins/neocomplete.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
  let neobundle#hooks.on_source = '~/.vim/plugins/neosnippet.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('editorconfig-vim') "{{{
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*', 'gista:.*']

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-textobj-user') "{{{
  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-operator-surround') "{{{
  nmap <silent>sa <Plug>(operator-surround-append)a
  nmap <silent>sd <Plug>(operator-surround-delete)a
  nmap <silent>sr <Plug>(operator-surround-replace)a
  nmap <silent>sc <Plug>(operator-surround-replace)a

  call neobundle#untap()
endif "}}}

if neobundle#tap('matchit.zip') "{{{
  function! neobundle#hooks.on_post_source(bundle) "{{{
    " https://gist.github.com/k-takata/3d8e909a1a4955de7572

    " Load matchit.vim
    runtime macros/matchit.vim

    function! s:set_match_words()
      " Enable these pairs for all file types
      let words = ['(:)', '{:}', '[:]', '（:）', '「:」']
      if exists('b:match_words')
        for w in words
          if b:match_words !~ '\V' . w
            let b:match_words .= ',' . w
          endif
        endfor
      else
        let b:match_words = join(words, ',')
      endif
    endfunction
    augroup matchit-setting
      autocmd!
      autocmd BufEnter * call s:set_match_words()
    augroup END

    silent! execute 'doautocmd Filetype' &filetype
  endfunction"}}}

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-fontzoom') "{{{
  nmap + <Plug>(fontzoom-larger)
  nmap _ <Plug>(fontzoom-smaller)

  call neobundle#untap()
endif "}}}

if neobundle#tap('tabular') "{{{
  vnoremap <silent> <Enter> :<C-u>'<,'>Tabularize/

  call neobundle#untap()
endif "}}}

if neobundle#tap('nerdtree') "{{{
  nmap <S-t> :<C-u>NERDTreeToggle<CR>
  let NERDTreeShowLineNumbers=0

  call neobundle#untap()
endif "}}}

if neobundle#tap('syntastic') "{{{
  let g:syntastic_ruby_checkers = ['rubocop']
endif "}}}
