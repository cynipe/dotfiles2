" skip if vim-tiny or vim-small
if !1 | finish | endif

if &compatible
  set nocompatible
endif

function! s:source_rc(path)
  execute 'source' fnameescape(expand('~/src/dotfiles/vim/' . a:path))
endfunction

let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_sudo = $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

function! IsWindows()
  return s:is_windows
endfunction

function! IsMac()
  return !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!executable('xdg-open') &&
      \     system('uname') =~? '^darwin'))
endfunction

call s:source_rc('init.rc.vim')

let g:neobundle_default_git_protocol = 'https'
call neobundle#begin(expand('$CACHE/neobundle'))

if neobundle#load_cache(
      \ expand('<sfile>'),
      \ '~/src/dotfiles/neobundle.toml',
      \ '~/src/dotfiles/neobundlelazy.toml')
  NeoBundleFetch 'Shougo/neobundle.vim'

  call neobundle#load_toml('~/src/dotfiles/vim/neobundle.toml')
  call neobundle#load_toml('~/src/dotfiles/vim/neobundlelazy.toml', {'lazy' : 1})

  NeoBundleSaveCache
endif

" plugins conf goes here
call s:source_rc('plugins.rc.vim')

call neobundle#end()
filetype plugin indent on
syntax enable

set background=dark
let g:solarized_termtrans = 1
colorscheme solarized




if !has('vim_starting')
  NeoBundleCheck
endif

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  exe 'set runtimepath+=' . globpath($GOPATH, 'src/github.com/golang/lint/misc/vim')
endif

" Default home directory.
let t:cwd = getcwd()

"-------------------------------------------------------------------------------
" 基本設定 Basics
"-------------------------------------------------------------------------------
let g:mapleader=","                " キーマップリーダー
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set visualbell t_vb=             " ビープをならさない
set browsedir=buffer             " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set nowrap                       " 行を折り返さない
set undodir=$HOME/.vim/undo      " *.un~ファイルの保存ディレクトリをまとめる
set secure


" Reloadable設定
" http://whileimautomaton.net/2008/08/vimworkshop3-kana-presentation
" Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC
" set hoge+=する場合はset hoge& hoge+=と書く
" commandはかならずcommand!とすること
" autocmdはautocmd R BuffEnter * ....と記述すること
augroup R
  autocmd!
augroup END

" http://nanasi.jp/articles/howto/editing/clipboard.html
if has('gui_running')
  " OSのクリップボードを使う
  set clipboard& clipboard+=unnamed
  " VisualModeで選択したテキストをクリップボードに入れる
  set guioptions& guioptions+=a
else
  " VisualModeで選択したテキストをクリップボードに入れる
  set clipboard& clipboard+=autoselect
endif

" ターミナルでマウスを使用できるようにする
set mouse=a
set ttymouse=xterm2

"-------------------------------------------------------------------------------
" 表示関連
"-------------------------------------------------------------------------------
set showmatch                                     " 括弧の対応をハイライト
set number                                        " 行番号表示
set list                                          " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex                                  " 印字不可能文字を16進数で表示
set cursorline                                    " カーソル行をハイライト
set lazyredraw                                    " コマンド実行中は再描画しない
set ttyfast                                       " 高速ターミナル接続を行う
set cursorline                                    " カーソル行をハイライト

" カレントウィンドウにのみ罫線を引く
autocmd R WinLeave * set nocursorline
autocmd R WinEnter,BufRead * set cursorline

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue
match ZenkakuSpace /　/

if (exists('+colorcolumn'))
  set colorcolumn=100
  highlight ColorColumn ctermbg=9
endif


"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set showcmd      " コマンドをステータス行に表示
set showmode     " 現在のモードを表示
set laststatus=2 " 常にステータスラインを表示
set ruler        "カーソルが何行目の何列目に置かれているかを表示する

"自動的に QuickFix リストを表示する
autocmd R QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
autocmd R QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

let g:Powerline_symbols = 'compatible'

"-------------------------------------------------------------------------------
" インデント Indent
"-------------------------------------------------------------------------------
" ファイル種別毎の設定は.editorconfigに任せることにする
set autoindent   " 自動でインデント
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent      " Cプログラムファイルの自動インデントを始める

"-------------------------------------------------------------------------------
" 補完・履歴 Complete
"-------------------------------------------------------------------------------
"
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete& complete+=k  " 補完に辞書ファイル追加

" Ex-modeでの<C-p><C-n>をzshのヒストリ補完っぽくする
cnoremap <C-p>  <Up>
cnoremap <Up>   <C-p>
cnoremap <C-n>  <Down>
cnoremap <Down> <C-n>

"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set wrapscan   " 最後まで検索したら先頭へ戻る
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
"<C-[>の2回押しでハイライト消去
nmap <C-[><C-[> :nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy:%s!<C-R>=escape(@x, '.*$^~[]')<CR>!!gc<Left><Left><Left>

" Command-line mode keymappings:"{{{
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
"}}}

" insert mode での移動
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-j> <DOWN>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"フレームサイズを怠惰に変更する
nnoremap <kPlus>   :<C-u>resize +5<Return>
nnoremap <kMinus>  :<C-u>resize -5<Return>

" 前回終了したカーソル行に移動
autocmd R BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 対応する括弧に移動
nnoremap [ %
nnoremap ] %

" 矩形選択で自由に移動する
set virtualedit& virtualedit+=block

"ビジュアルモード時vで行末まで選択
vnoremap v $h

"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------

" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set nofoldenable
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
nnoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

"-------------------------------------------------------------------------------
" Encoding
"-------------------------------------------------------------------------------
call s:source_rc('encoding.rc.vim')

"-------------------------------------------------------------------------------
" Basic
" toggle transparency
nnoremap <C-l>      :<C-u>let &transparency=&transparency == 10 ? 30 : 10<CR>
nnoremap <C-i>      :<C-u>help<Space>
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><CR>
nnoremap <S-s>      :<C-u>VimShellPop -buffer-name=terminal<CR>
nnoremap <S-u>      <SID>(gundo-toggle)
nnoremap <C-x>      :<C-u>FixWhitespace<CR>
nnoremap <C-z>      :%s/\t/  /ge<CR>

" Visual mode keymappings: "{{{
" <TAB>: indent.
xnoremap <TAB>  >
" <S-TAB>: unindent.
xnoremap <S-TAB>  <

" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

if has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
"}}}

nnoremap [git] <Nop>
nmap <Space> [git]

nnoremap [git]s :<C-u>Gstatus<CR>
nnoremap [git]d :<C-u>Gdiff<CR>
nnoremap [git]b :<C-u>Gblame<CR>
nnoremap [git]c :<C-u>Gcommit<CR>
nnoremap [git]C :<C-u>Git commit --amend<CR>
nnoremap [git]l :<C-u>Unite -start-insert giti/log<CR>
nnoremap [git]B :<C-u>Unite -no-split -start-insert giti/branch<CR>
nnoremap [git]f :<C-u>Unite -no-split -start-insert giti/diff_tree/changed_files:master:HEAD:--diff-filter=AM<CR>
