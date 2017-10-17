call plug#begin()

" customization
Plug 'flazz/vim-colorschemes'

" file management
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'

" extra functionality
Plug 'qpkorr/vim-bufkill'
Plug 'vim-scripts/YankRing.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'mileszs/ack.vim'
Plug 'SirVer/ultisnips'

if !has('win32')
	Plug 'Rip-Rip/clang_complete'
end

" linting
Plug 'w0rp/ale'

" filetypes
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'nightsense/carbonized'

call plug#end()

filetype plugin indent on
syntax enable

set termguicolors
set t_ut=

" set Vim-specific sequences for RGB colors
let &t_8f = "[38;2;%lu;%lu;%lum"
let &t_8b = "[48;2;%lu;%lu;%lum"

let &t_SI = "[6 q"
let &t_SR = "[4 q"
let &t_EI = "[2 q"

let g:my_vim_folder = split(&rtp, ',')[0]

" Vim Settings
set exrc

" My Keymaps
" custom {{{
let mapleader = " "

" auto insert curly braces on CTRL-f
imap <C-F> {<CR>}<C-O>O

" open vimrc
nmap <LocalLeader>v :edit $MYVIMRC<CR>

" reload vimrc
nmap <LocalLeader>o :source $MYVIMRC<CR>
nmap <LocalLeader>r :source %<CR>

" remove unwanted search highlighting by searching
" for something that will probably never be found
nmap <LocalLeader>h :set nohlsearch<CR>

" open and close the quickfix/searchresults window
nmap <LocalLeader>f :botright copen<CR>
nmap <LocalLeader>x :cclose<CR>

" split function params into multiple lines
nmap <LocalLeader>b /(<CR>malvh%hxi<CR><Esc>==O<C-r>"<Esc>==`a%kA,<Esc>`avi(:s/,\(\s\)\?/,\r/g<CR>`avi(=`avi(V:s/\n\n/\r/g<CR>/dhj8nb4yipq7<CR>

" vimgrep for word under cursor
nmap <LocalLeader>g viwy:call AckForSelection()<CR>
vmap <LocalLeader>g :call AckForSelection()<CR>

" perl align
nmap <LocalLeader>a :e ~/.vim/bin/align.pl<CR>
vmap <LocalLeader>a :!perl ~/.vim/bin/align.pl -c:=

nnoremap / :set hls<CR>/
" custom }}}
" enhancements {{{
" make indentation easier by default
nnoremap < <<
nnoremap > >>

" make indentation keep selection intact
vnoremap > >gv
vnoremap < <gv

" keep cursor on same relative line during in-place scroll
nnoremap <C-e> j<C-e>
nnoremap <C-y> k<C-y>
" enhancements }}}
" alt_keys {{{
"
" IMPORTANT: depends on win32_utf8_shim
"
" ALT-c copy
" ALT-v paste
" ALT-s save
" ALT-w close
" ALT-w quit
" ...and more...

nnoremap <M-a> ggVG
vnoremap <M-c> "+y
vnoremap <M-x> "+x
nnoremap <M-v> "+p
nnoremap <M-V> "+P
inoremap <M-v> <C-r>"
inoremap <M-q> :qa!<CR>

" save
nnoremap <M-s> :wa<CR>

" close
nnoremap <M-w> :BD<CR>
" alt_keys }}}
" plugins {{{
nmap <LocalLeader>t :TagbarToggle<CR>
nmap <LocalLeader>n :NERDTreeToggle<CR>

" custom
nmap <LocalLeader>w :call ToggleWrap()<CR>
nmap <LocalLeader>s :call StripWhitespace()<CR>
nmap <LocalLeader>m :call ToggleMousePaste()<CR>

let g:ctrlp_map = "<Leader>t"

nmap <Leader>js :call logger#word()<CR>
nmap <Leader>jv :call logger#line()<CR>
nmap <Leader>jc :call GetClosure()<CR>

nmap <F5> :GoInstall<CR>
vmap <F5> :GoInstall<CR>
imap <F5> :GoInstall<CR>
" plugins }}}

" My Settings
" C++ include paths {{{
set path+=/usr/include/linux,/usr/include/c++/v1,/usr/include/libcxxabi,/usr/local/include
" C++ include paths }}}
" cindent {{{
set cindent
set cinoptions=
set cinoptions+=t0
set cinoptions+=j1
set cinoptions+=m1
set cinoptions+=(s
set cinoptions+=N-s
" cindent }}}
" colors {{{
"hi Folded guifg=#dddddd guibg=#222222
if has('gui_running')
	colorscheme OceanicNext
	set background=dark
else
	colorscheme OceanicNext
	set background=dark
end
" colors }}}
" font {{{
if has('gui_running')
	if has('win32')
		set guifont=DejaVu_Sans_Mono:h12
	elseif has('unix')
		if has('macunix')
			set guifont=DejaVu\ Sans\ Mono:h16
		else
			set guifont=DejaVu\ Sans\ Mono\ 12
		endif
	endif
endif
" font }}}
" indentation {{{
set expandtab
set autoindent
set tabstop=8
set shiftwidth=2
set softtabstop=2
set nosmartindent
" indentation }}}
" listchars {{{
if has('win32') && has("gui_running")
	" windows needs to have utf-8
	" encoding forced so we can see
	" fun characters
	set encoding=utf-8
end

if !has('win32') || has("gui_running")
	" if it's not windows then the special chars work anywhere
	" if it's windows, then special chars only work in GUI

	set list " show visible non-printing and special characters
	set listchars=tab:\→\ ,trail:\‣,extends:\↷,precedes:\↶

	" other examples

	" set listchars=tab:\⇒\─,trail:\‣,extends:\↷,precedes:\↶
	" set listchars=tab:\→\ ,trail:\‣,extends:\↷,precedes:\↶
	" set listchars=tab:\↴\⇒,trail:\⎕,extends:\↻,precedes:\↺,eol:\↵
	" set listchars=tab:\┼\─,trail:\˽,extends:\↷,precedes:\↶
end
" listchars }}}
" options {{{
" general
set hidden " don't unload buffers
set wildmenu " tab completion for :ex-commands
set number " show line numbers
set ruler " show column number
set autoread " auto reload changed files
set winaltkeys=no " don't trigger menus on alt key
" set guioptions=aegimrLtT
"set guioptions=aegimrLtT

" folding
set foldmethod=marker

set colorcolumn=60
" options }}}
" search {{{
set noignorecase
"set smartcase
set incsearch
set hlsearch
set nowrap
set showmatch
" search }}}
" statusline {{{
set laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%{fugitive#statusline()}%=%-16(\ %l,%c\ %)%P
" statusline }}}
" swap_files {{{
if has('win32')
	if exists('my_diff_mode_flag') && my_diff_mode_flag == 1
		set directory=~\.swpdiff,~,.
	else
		set directory=~\.swp,~,.
	endif
elseif has('unix')
	if exists('my_diff_mode_flag') && my_diff_mode_flag == 1
		set directory=~/.swpdiff,~,.
	else
		set directory=~/.swp,~,.
	endif
endif
" swap_files }}}

" Plugin Settings
" Ack.vim {{{
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" }}}
" clang_complete {{{

" from github README:
"	path to directory where library can be found
"	let g:clang_library_path='/usr/lib/llvm-3.8/lib'
"
"	or path directly to the library file
"	let g:clang_library_path='/usr/lib64/libclang.so.3.8'

" ubuntu
if !has('win32')
	let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-3.8.so.1'
	let g:clang_auto_select = 1
	let g:clang_complete_auto = 0
	let g:clang_complete_copen = 1
end
" clang_complete }}}
" Golang {{{
let g:go_fmt_command = "goimports"
"let g:go_fmt_options = "-f " . expand("%:p")

let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

let g:go_metalinter_autosave_enabled = ['vet', 'golint']

let g:go_metalinter_deadline = "5s"
" }}}
" ale {{{
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1

" ['go build', 'gofmt', 'golint', 'gometalinter', 'gosimple', 'go vet', 'staticcheck']
let g:ale_linters = {'c': ['clang'], 'cpp': ['clang'], 'go': ['gofmt', 'go vet', 'go build']}
" ale }}}
" syntastic {{{
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_javascript_eslint_exec = 'eslint_wrapper'
"let g:syntastic_async = 1
" }}}
" matchit {{{
" don't load the matchparen plugin
let loaded_matchparen = 1
" }}}
" CTRL-p {{{
let g:ctrlp_custom_ignore = '\.node_modules\|\.DS_Store\|\.git\|vendor'
" }}}
" JSX {{{
let g:jsx_ext_required = 1
" }}}
" NERDTree {{{
" prevent annoying warnings from nerdtree
let g:NERDShutUp = 1
" }}}
" yankring {{{
" use a vertical window split
let g:yankring_window_use_horiz = 0

let g:yankring_history_dir = '~/.yankring,~/.swp,~/.tmp,~/tmp,/tmp,~/.vim,~/vimfiles'

" don't include single character deletes
let g:yankring_min_element_length = 2

" truncate each paste at 50 chars to keep the window width small
let g:yankring_max_display        = 50
" }}}
" ruby {{{
"
"   don't bother to colorize end tags differently
"   based on what type of block is being ended
"   hopefully this means faster loads and better
"   syntax hilite with folds
let ruby_no_expensive = 1
" }}}

" Shims
" win32_utf8_shim {{{
if has('win32') && has('gui_running')
	" windows needs to have utf-8
	" encoding forced so we can see
	" fun characters
	set encoding=utf-8
end
" win32_utf8_shim }}}
" shim_prefs {{{
" keep relative line number on permanently/by default
autocmd BufNew,BufRead * setlocal relativenumber

" keep cursor at least one line down while scrolling
if !&scrolloff
	set scrolloff=1
endif

" keep cursor at least x number of chars inwards as we scroll
if !&sidescrolloff
	set sidescrolloff=5
endif

" make arrow keys and backspacing over lines more natural
set backspace=2
set whichwrap=b,s,h,l,[,],<,>

" show long lines instead of truncating with @ symbol
" show unprintable chars as HEX codes
set display=lastline,uhex

" make sure sessions remember window size
set sessionoptions+=resize

" don't force splits to be any width at all
set winminheight=0
set winminwidth=0
" shim_prefs }}}
" terminal_color_shim {{{
if !has('gui_running')
	if &t_Co == 8 && $TERM !~# '^linux'
		set t_Co=16
	endif

	set mouse=a
end
" terminal_color_shim }}}
" windows_shell_fix {{{
if has('win32')
	" fix the behavior of escaping etc when using
	" the standard windows command prompt
	set shell=C:\Windows\System32\cmd.exe
	set shellcmdflag=/c
	set shellxquote=(
	"set shellredir=>%s 2>&1
endif
" windows_shell_fix }}}

" Functions
" ToggleFold {{{
function! ToggleFold()
	if foldlevel('.') == 0
		normal! l
	else
		if foldclosed('.') < 0
			. foldclose
		else
			. foldopen
		endif
	endif

	" Clear status line
	echo
endfunction
" ToggleFold }}}
" ToggleMousePaste {{{
function! ToggleMousePaste()
	if &mouse == 'a'
		set paste
		set mouse=
		set nonumber
		echo 'Mouse Paste ON'
	else
		set nopaste
		set number
		set mouse=a
		echo 'Mouse Paste OFF'
	endif
endfunction
" ToggleMousePaste }}}
" ToggleRelativeNumber {{{
function! ToggleRelativeNumber()
	if( &nu == 1 )
		set nonu
		set rnu
	else
		set nu
		set nornu
	endif
endfunction

function! ToggleRelativeNumberVisual()
	call ToggleRelativeNumber()
	normal gvj
endfunction
" relative_line_number }}}
" StripWhitespace {{{
function! StripWhitespace()
  let currPos=Mark()
  exe 'v:^--\s*$:s:\s\+$::e'
  exe currPos
endfunction

function! Mark(...)
	if a:0 == 0
		let mark = line('.') . 'G' . virtcol('.') . '|'
		normal! H
		let mark = 'normal!' . line('.') . 'Gzt' . mark
		execute mark
		return mark
	elseif a:0 == 1
		return 'normal!' . a:1 . 'G1|'
	else
		return 'normal!' . a:1 . 'G' . a:2 . '|'
	endif
endfunction
" StripWhitespace }}}
" ToggleWrap {{{
function! ToggleWrap()
	set wrap!

	if( &wrap == 1 )
		nmap j gj
		nmap k gk
	else
		unmap j
		unmap k
	endif
endfunction
" ToggleWrap }}}
" GetClosure {{{
function! GetClosure()
	let closure = ''
	let syntax_type = &ft

	normal ma
	if syntax_type == 'cpp'
		let closure = "[](auto& x) {\nreturn x;\n}"
	elseif syntax_type == 'javascript' || syntax_type == 'javascript.jsx'
		let closure = "(x) => {\nreturn x;\n}"
	elseif syntax_type == 'ruby'
		let closure = '{ |x| x * x }'
	endif

	exe 'normal i' . closure
	normal k^
endfunction
" GetClosure }}}
" AckForSelection {{{
function! AckForSelection()
  " escape PCRE regex chars
  let search_term = substitute(GetVisualSelection(), '\([.*+?()]\)', '\\\1', 'g')

  let dirs = get(g:, 'ack_dirs', 'src')
  echo dirs
  let cmd = "Ack '" . search_term . "' " . dirs

  " run the search
  execute cmd

  " open the search results window
  botright copen
endfunction

function! GetVisualSelection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction
" AckForSelection }}}
" OpenNerdtree {{{
function! OpenNerdtree()
	" open nerdtree when vim starts and
	" navigate to a custom folder
	"
	" autocmd VimEnter * NERDTree
	" autocmd VimEnter * normal 3jo5jo2jo

	NERDTree
	set relativenumber
endfunction
" OpenNerdtree }}}
" SetupColorschemesMenu {{{
function! SetupColorschemesMenu()
	let colorscheme_menu_files = split(globpath('~/.vim/plugged/vim-colorschemes/colors', '*'), '\n')
	for i in range(1,len(colorscheme_menu_files)-1)
		let scheme_name = fnamemodify(fnamemodify(colorscheme_menu_files[i], ":r"), ":t")
		exec 'menu Plugin.Colorschemes.' . scheme_name . ' :colorscheme ' . scheme_name . '<CR>'
	endfor
endfunction
" SetupColorschemesMenu }}}
