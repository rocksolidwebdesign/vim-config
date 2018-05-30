" vim: set noet ts=8 sw=8 sts=8 foldmethod=marker
function! s:init()
	call s:configure_language_defaults()
endfunction

function! s:get_config_val(var_name, default_val)
	return get(b:, a:var_name, get(g:, a:var_name, a:default_val))
endfunction

" languages {{{
function! s:configure_language_defaults()
	call s:set_default('logger_shut_up', 0)

	call s:set_default('logger_go_label_suffix', ':')
	call s:set_default('logger_go_prefix', 'fmt.Println(')
	call s:set_default('logger_go_suffix', ')')

	call s:set_default('logger_javascript_prefix', 'console.log(')
	call s:set_default('logger_javascript_label_suffix', ':')

	call s:set_default('logger_javascript_jsx_prefix', 'console.log(')
	call s:set_default('logger_javascript_jsx_label_suffix', ':')

	call s:set_default('logger_python_arg_separator', ' + ')
	call s:set_default('logger_python_token_prefix', 'str(')
	call s:set_default('logger_python_token_suffix', ')')
	call s:set_default('logger_python_prefix', 'print(')
	call s:set_default('logger_python_suffix', ')')

	call s:set_default('logger_vim_arg_separator', ' . ')
	call s:set_default('logger_vim_prefix', 'echo ')
	call s:set_default('logger_vim_suffix', '')

	call s:set_default('logger_cpp_arg_separator', ' << ')
	call s:set_default('logger_cpp_prefix', 'std::cout << ')
	call s:set_default('logger_cpp_suffix', ' << std::endl;')

	call s:set_default('logger_cmake_prefix', 'message("')
	call s:set_default('logger_cmake_suffix', '")')
	call s:set_default('logger_cmake_token_prefix', ' ${')
	call s:set_default('logger_cmake_token_suffix', '}')
	call s:set_default('logger_cmake_quote_char', '')
	call s:set_default('logger_cmake_arg_separator', '')
	call s:set_default('logger_cmake_label_suffix', '')
endfunction
" languages }}}
" main {{{
function! logger#word()
	let input = expand('<cWORD>')
	let output = s:concat_var_output(input)

	call s:do_log(output)
endfunction

function! logger#line()
	let input = s:trim_line()
	let output = s:concat_line_output(input)

	call s:do_log(output)
endfunction

function! s:do_log(value)
	if s:is_loggable()
		call setline('.', s:copy_indent() . a:value)
	endif

	normal 0w
endfunction

function! s:concat_var_output(token)
	let result = ''

	let st = s:syntax_type()

	let quote_char    = s:get_config_val('logger_'.st.'_quote_char',     '"')
	let line_prefix   = s:get_config_val('logger_'.st.'_prefix',         'print(')
	let line_suffix   = s:get_config_val('logger_'.st.'_suffix',         ');')
	let token_prefix  = s:get_config_val('logger_'.st.'_token_prefix',   '')
	let token_suffix  = s:get_config_val('logger_'.st.'_token_suffix',   '')

	let label_suffix  = s:get_config_val('logger_'.st.'_label_suffix',   ': ')
	let arg_separator = s:get_config_val('logger_'.st.'_arg_separator',  ', ')

	let result = line_prefix . quote_char . a:token . label_suffix . quote_char . arg_separator . token_prefix . a:token . token_suffix . line_suffix

	return result
endfunction

function! s:concat_line_output(value)
	let result = ''

	let st = s:syntax_type()

	let quote_char   = s:get_config_val('logger_'.st.'_quote_char',    '"')
	let line_prefix  = s:get_config_val('logger_'.st.'_prefix',        'print(')
	let line_suffix  = s:get_config_val('logger_'.st.'_suffix',        ');')
	let token_prefix = s:get_config_val('logger_'.st.'_token_prefix',  '')
	let token_suffix = s:get_config_val('logger_'.st.'_token_suffix',  '')

	let log_line = line_prefix . quote_char . a:value . quote_char . line_suffix

	return log_line
endfunction
" main }}}
" utility {{{
function! s:set_default(name, val)
	if !exists(a:name)
		exec 'let g:'.a:name.' = get(g:, a:name, a:val)'
	endif
endfunction

function! s:copy_indent()
	return substitute(getline('.'), '^\(\s*\)\S.*', '\1', 'g')
endfunction

function! s:trim_line()
	return substitute(getline('.'), '^\s*\(.*\)\s*$', '\1', '')
endfunction

function! s:syntax_type()
	return substitute(&ft, '\.', '_', 'g')
endfunction

function! s:is_loggable()
	let st = s:syntax_type()

	let line_prefix = s:get_config_val('logger_'.st.'_prefix',  '')

	if line_prefix ==? ''
		if !g:logger_shut_up
			echo 'missing logger settings for ' . st
		endif

		return 0
	endif

	return 1
endfunction
" utility }}}

call s:init()
