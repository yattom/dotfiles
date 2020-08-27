" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

" deinİ’è QÆ: http://qiita.com/delphinus/items/00ff2c0ba972c6e41542
" ãè‚­“®‚©‚È‚¢‚Ì‚Å‚¢‚Á‚½‚ñŠO‚µ‚Ä‚¨‚­ 2017.3.15
if 1  "‚±‚±‚©‚ç...
" vimrc ‚ÉˆÈ‰º‚Ì‚æ‚¤‚É’Ç‹L

" ƒvƒ‰ƒOƒCƒ“‚ªÀÛ‚ÉƒCƒ“ƒXƒg[ƒ‹‚³‚ê‚éƒfƒBƒŒƒNƒgƒŠ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim –{‘Ì
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim ‚ª‚È‚¯‚ê‚Î github ‚©‚ç—‚Æ‚µ‚Ä‚­‚é
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  " ‰º‚Ìs‚Í––”ö‚É'\'‚ğ’Ç‰Á‚·‚é‚ªA‚»‚ê‚¾‚Æ“®‚©‚È‚¢–Í—l
  " execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" İ’èŠJn
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " ƒvƒ‰ƒOƒCƒ“ƒŠƒXƒg‚ğû‚ß‚½ TOML ƒtƒ@ƒCƒ‹
  " —\‚ß TOML ƒtƒ@ƒCƒ‹iŒãqj‚ğ—pˆÓ‚µ‚Ä‚¨‚­
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  " let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML ‚ğ“Ç‚İ‚İAƒLƒƒƒbƒVƒ…‚µ‚Ä‚¨‚­
  call dein#load_toml(s:toml,      {'lazy': 0})
  " call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " İ’èI—¹
  call dein#end()
  call dein#save_state()
endif

" ‚à‚µA–¢ƒCƒ“ƒXƒg[ƒ‹‚à‚Ì‚à‚Ì‚ª‚ ‚Á‚½‚çƒCƒ“ƒXƒg[ƒ‹
if dein#check_install()
  call dein#install()
endif

endif  "‚±‚±‚Ü‚Å
" deinİ’è ‚±‚±‚Ü‚Å



" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
set ts:4
set sts:4
set sw:4
set ic
set ai
set bk
set vb
set nu
set guifont=Ricty_Diminished_Discord:h13:cSHIFTJIS:qDRAFT
highlight Normal guibg=#000040 guifg=White
highlight LineNr guifg=#C000C0 guibg=#404040 cterm=underline
highlight Search guibg=#004000 cterm=reverse ctermfg=DarkGreen
set background=dark
syntax on
set bs=indent,eol
set showmatch
set hlsearch
set incsearch
filetype indent on
filetype plugin on
set hidden
" •¶šƒR[ƒh‚Ì˜b‚Í‚±‚±‚ğQÆ http://www.kawaz.jp/pukiwiki/?vim#p0799eb
" set encoding=utf-8
set encoding=cp932
set fileencodings=utf-8
set ambiwidth=double


autocmd FileType python setlocal expandtab
" autocmd FileType python source ~/.vim/python.vim
autocmd FileType html setlocal expandtab sts=2 ts=2 tw=0 sw=2
autocmd FileType xhtml setlocal expandtab sts=2 ts=2 tw=0 sw=2
autocmd FileType ruby setlocal expandtab sts=2 ts=2 tw=0 sw=2
autocmd FileType eruby setlocal expandtab sts=2 ts=2
autocmd FileType javascript setlocal expandtab sts=2 ts=2 sw=2
autocmd FileType coffee setlocal expandtab sts=2 ts=2 sw=2
autocmd FileType dot setlocal expandtab sts=2 ts=2 tw=0 sw=2

autocmd FileType perl setlocal noexpandtab

" for cucumber (*.feature) scenarios
" From http://github.com/tpope/vim-cucumber/tree/master/syntax
autocmd BufRead,BufNewFile *.feature set filetype=cucumber

" From http://d.hatena.ne.jp/mig50/20060731/1154356587
" rails.vim
let g:rails_level=4
let g:rails_default_file="app/controllers/application.rb"
let g:rails_default_database="sqlite3"

" rubycomplete.vim
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

" From this page:
" http://wiki.rubyonrails.org/rails/pages/HowtoUseVimWithRails
" Automatic jumping to classes
set path+=/path/to/your/rails-application/app/**
set path+=/path/to/your/rails-application/lib/**
set suffixesadd=.rb
set includeexpr+=substitute(v:fname,'s$','','g')

" Avoiding MVC same-name clashes
map <F11> <Esc>:set suffixesadd=.rb<CR>gf
map <F12> <Esc>:set suffixesadd=.rhtml<CR>gf

" using moin.vim from http://moinmoin.wikiwikiweb.de/VimHighlighting
augroup filetypedetect
au BufNewFile,BufRead *.moin setf moin
au BufNewFile,BufRead *.wiki setf moin
augroup END

" scala
au BufRead,BufNewFile *.scala set filetype=scala

" other filetypes
au BufRead,BufNewFile *.as set filetype=actionscript
au BufRead,BufNewFile *.mxml set filetype=mxml

"" for screen hardstatus title display
"" http://goungoun.dip.jp/app/fswiki/wiki.cgi/devnotebook?page=screen
"function SetScreenTabName(name)
"  let arg = 'k' . a:name . '\\'
"  silent! exe '!echo -n "' . arg . "\""
"endfunction
"
"if &term =~ "screen"
"  autocmd VimLeave * call SetScreenTabName('** free **')
"  autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | call SetScreenTabName("%") | endif
"endif

" highliting whitespaces at EOL
" http://d.hatena.ne.jp/tasukuchan/20070816/1187246177
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/

" highliting tabs
"highlight Tab ctermbg=darkred guibg=darkred
"match Tab /\t/
"autocmd WinEnter *.py match Tab /\t/
set list
set listchars=tab:>\ 
highlight SpecialKey guifg=darkcyan term=NONE

"mkdir on save when no parent directories
"http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save/4294176#4294176
augroup BWCCreateDir
	au!
	autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) | redraw! | endif
augroup END
