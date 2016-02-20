let g:unite_enable_auto_select = 0
let g:unite_enable_start_insert = 1
let g:unite_enable_smart_case = 1
let g:unite_source_history_yank_enable = 0

function! s:unite_my_settings() "{{{
  nmap <buffer> <ESC>       <Plug>(unite_exit)
  nmap <buffer> <ESC><ESC>  <Plug>(unite_exit)

  imap <buffer> jj          <Plug>(unite_insert_leave)
  imap <buffer> <C-w>       <Plug>(unite_delete_backward_path)
  imap <buffer> <BS>        <Plug>(unite_delete_backward_path)

  " Unite中に<C-p>でPreview
  nnoremap <silent><buffer> <C-p> <Plug>(unite_toggle_auto_preview)
  " ウィンドウを分割して開く
  nnoremap <expr><silent><buffer> <C-s> unite#do_action('split')
  inoremap <expr><silent><buffer> <C-s> unite#do_action('split')
  " ウィンドウを縦に分割して開く
  nnoremap <expr><silent><buffer> <C-v> unite#do_action('vsplit')
  inoremap <expr><silent><buffer> <C-v> unite#do_action('vsplit')
endfunction
autocmd MyAutoCmd FileType unite call s:unite_my_settings()


" Default configuration.
let default_context = {
      \ 'vertical' : 0,
      \ 'short_source_names' : 1,
      \ }
call unite#custom#profile('default', 'context', default_context)

if executable('hw')
  " Use hw(highway)
  " https://github.com/tkengo/highway
  let g:unite_source_grep_command = 'hw'
  let g:unite_source_grep_default_opts = '--no-group --no-color --follow-link'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  " Use pt(the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --follow-link'
  let g:unite_source_grep_recursive_opt = ''
endif

