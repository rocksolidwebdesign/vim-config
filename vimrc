set nocompatible
filetype off

if has('win32')
	set rtp+=~/vimfiles/bundle/Vundle.vim
else
	set rtp+=~/.vim/bundle/Vundle.vim
end

call vundle#begin()

" customization
Plugin 'flazz/vim-colorschemes'

" file management
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

" extra functionality
Plugin 'qpkorr/vim-bufkill'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive' " git happy

" linting
Plugin 'vim-syntastic/syntastic'

" filetypes
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'fatih/vim-go'

call vundle#end()

filetype plugin indent on
syntax enable

" Functions
" toggle_fold {{{
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
" toggle_fold }}}
" mouse_paste {{{
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
" mouse_paste }}}
" relative_line_number {{{
function! ToggleRelativeNumberVisual()
	call ToggleRelativeNumber()
	normal gvj
endfunction

function! ToggleRelativeNumber()
	if( &nu == 1 )
		set nonu
		set rnu
	else
		set nu
		set nornu
	endif
endfunction
" relative_line_number }}}
" strip_whitespace {{{
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
" strip_whitespace }}}
" word_wrap {{{
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
" word_wrap }}}
" perl_align {{{
vmap <LocalLeader>a :!perl ~/.vim/bin/align.pl<CR>gv=gv:s/\s*$//<CR>
" perl_align }}}
" quick_closure {{{
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
" quick_closure }}}
" logger {{{
let g:is_logger = 0

function! GetLoggingStatement(token, label)
	let token = a:token
	let label = a:label

	let joiner = ''
	let log_line = ''
	let line_prefix = ''
	let line_suffix = ''

	let syntax_type = &ft
	if syntax_type == 'python'
		let line_prefix = 'print('
		let line_suffix = ')'

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '"' . token . '"'
		elseif  strlen(token) <= 0 && strlen(label) > 0
			let label = '"' . label . '"'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = line_suffix . "\n" . line_prefix
		else
			let joiner = ''
		endif

	elseif syntax_type == 'go'
		let line_prefix = 'fmt.Println('
		let line_suffix = ')'

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '"' . token . '"'
		elseif  strlen(token) <= 0 && strlen(label) > 0
			let label = '"' . label . '"'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = line_suffix . "\n" . line_prefix
		else
			let joiner = ''
		endif

	elseif syntax_type == 'elixir'
		let line_prefix = 'IO.inspect('
		let line_suffix = ')'

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '"' . token . '"'
		elseif  strlen(token) <= 0 && strlen(label) > 0
			let label = '"' . label . '\n"'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = line_suffix . "\n" . line_prefix
		else
			let joiner = ''
		endif

	elseif syntax_type == 'erlang'
		let line_prefix = 'io:format('
		let line_suffix = ')'

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '"' . token . ' = ~w\n", '
			let token = '[' . token . ']'
		elseif  strlen(token) <= 0 && strlen(label) > 0
			let label = '"' . label . '\n"'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = ''
		else
			let joiner = ''
		endif

	elseif syntax_type == 'cpp'
		if g:is_logger
			let line_prefix = 'LOGGER << '
			let line_suffix = ' << std::endl;'
		else
			let line_prefix = 'std::cout << '
			let line_suffix = ' << std::endl;'
		endif

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '"' . token . ' = "'
		elseif  strlen(token) <= 0 && strlen(label) > 0
			let label = '"' . label . '"'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = ' << '
		else
			let joiner = ''
		endif

	elseif syntax_type == 'java'
		let line_prefix = 'System.out.println('
		let line_suffix = ');'

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '"' . token . '"'
		elseif strlen(token) <= 0 && strlen(label) > 0
			let label = '"' . label . '"'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = line_suffix . "\n" . line_prefix
		else
			let joiner = ''
		endif
	elseif syntax_type == 'javascript' || syntax_type == 'javascript.jsx'
		let line_prefix = 'console.log('
		let line_suffix = ');'

		if strlen(token) > 0 && strlen(label) <= 0
			let label = '`' . token . '`'
		elseif strlen(token) <= 0 && strlen(label) > 0
			let label = '`' . label . '`'
		else
			let label = label
		endif

		if strlen(token) > 0 && strlen(label) > 0
			let joiner = line_suffix . "\n" . line_prefix
		else
			let joiner = ''
		endif
	endif

	let log_line = line_prefix . label . joiner  . token . line_suffix

	return log_line
endfunction

function! GetVarLogOutput()
	let loggingTarget = expand('<cWORD>')

	let loggingOutput = GetLoggingStatement(loggingTarget, '')

	return loggingOutput
endfunction

function! GetLineLogOutput()
	let curLine = getline('.')
	let pat = '^\s*\(.*\)\s*$'
	let loggingTarget = substitute(curLine, pat, '\1', '')

	let loggingOutput = GetLoggingStatement('', loggingTarget)

	return loggingOutput
endfunction

function! QuickLoggerVar()
	let result = GetVarLogOutput()

	" save cursor position
	normal ma

	" paste the result
	put =result

	" restore cursor position
	normal 'a

	" remove empty line
	normal dd

	" indent what we pasted
	normal =j
endfunction

function! QuickLoggerLine()
	let result = GetLineLogOutput()

	" save cursor position
	normal ma

	" paste the result
	put =result

	" restore cursor position
	normal 'a

	" remove empty line
	normal dd

	" indent what we pasted
	normal ==
endfunction
" logger }}}

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

" Plugin Settings
" my custom logger {{{
let g:is_logger=1
" }}}
" Golang {{{
let g:go_fmt_command = "goimports"

let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

let g:go_metalinter_autosave_enabled = ['vet', 'golint']

let g:go_metalinter_deadline = "5s"
" }}}
" syntastic {{{
let g:syntastic_javascript_checkers = ['eslint']
" }}}
" matchit {{{
" don't load the matchparen plugin
let loaded_matchparen = 1
" }}}
" CTRL-p {{{
let g:ctrlp_map = "<Leader>p"
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

" Vim Settings
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
if has('gui_running')
	"colorscheme visualstudio
	"set background=light

	colorscheme molokai
	"hi Folded guifg=#dddddd guibg=#222222
else
	colorscheme molokai
	hi Folded guifg=#dddddd guibg=#222222
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
set guioptions=aegimrLtT

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
" templates {{{
" easy insert of code starter templates
let g:my_vim_folder = split(&rtp, ',')[0]
execute 'nnoremap <Leader>htm :read ' . g:my_vim_folder . '/templates/template.html<CR>kJ'
execute 'nnoremap <Leader>c :read ' . g:my_vim_folder . '/templates/template.cpp<CR>kJ'
" templates }}}

" Keymaps
" keymaps {{{
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
nmap <LocalLeader>h /dhj8nb4yipq7<CR>

" open and close the quickfix/searchresults window
nmap <LocalLeader>f :botright copen<CR>
nmap <LocalLeader>x :cclose<CR>
vmap <LocalLeader>, :s/$/,/<CR>/dhj8nb4yipq7<CR>

" split function params into multiple lines
nmap <LocalLeader>b /(<CR>malvh%hxi<CR><Esc>==O<C-r>"<Esc>==`a%kA,<Esc>`avi(:s/,\(\s\)\?/,\r/g<CR>`avi(=`avi(V:s/\n\n/\r/g<CR>/dhj8nb4yipq7<CR>

" keymaps }}}
" keymap_enhancements {{{
" make indentation easier by default
nnoremap < <<
nnoremap > >>

" make indentation keep selection intact
vnoremap > >gv
vnoremap < <gv

" keep cursor on same relative line during in-place scroll
nnoremap <C-e> j<C-e>
nnoremap <C-y> k<C-y>
" keymap_enhancements }}}
" keymap_pseudo_compat {{{
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
nnoremap <M-s> :w<CR>
nnoremap <M-S> :wa<CR>

" close
nnoremap <M-w> :BD<CR>
" keymap_pseudo_compat }}}

" Plugin Keymaps
" keymap_plugins {{{
nmap <LocalLeader>t :TagbarToggle<CR>
nmap <LocalLeader>n :NERDTreeToggle<CR>

" my plugins
nmap <LocalLeader>w :call ToggleWrap()<CR>
nmap <LocalLeader>m :call ToggleMousePaste()<CR>
nmap <LocalLeader>s :call StripWhitespace()<CR>

nmap <Leader>jsy :call QuickLoggerVar()<CR>
nmap <Leader>jsl :call QuickLoggerLine()<CR>
nmap <Leader>jsc :call GetClosure()<CR>
nmap <F5> :GoInstall<CR>
vmap <F5> :GoInstall<CR>
imap <F5> :GoInstall<CR>
" keymap_plugins }}}
