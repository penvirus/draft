let g:NCIPdebugger_debug_level = 0

function! NCIPdebugger_WriteLog(severity, fmt, ...)
    if a:severity <= g:NCIPdebugger_debug_level
	if exists('*strftime')
	    let l:current_time = strftime('%Y/%m/%d %H:%M:%S')
	else
	    let l:current_time = '[no strftime]'
	endif

	if a:severity == 1
	    let l:severity_char = 'E'
	else
	    let l:severity_char = 'D'
	endif

	if a:0 == 0
	    let l:arglist = ['%-28s%-6s%s', l:current_time, l:severity_char, a:fmt]
	else
	    let l:arglist = ['%-28s%-6s' . a:fmt, l:current_time, l:severity_char] + a:000
	endif

	redir >>NCIPdebugger.log
	silent echo call('printf', l:arglist)
	redir END
    endif
endfunction

function! NCIPdebugger_Error(fmt, ...)
    let l:arglist = [1, a:fmt] + a:000
    call call('NCIPdebugger_WriteLog', l:arglist)
endfunction

function! NCIPdebugger_Debug(fmt, ...)
    let l:arglist = [2, a:fmt] + a:000
    call call('NCIPdebugger_WriteLog', l:arglist)
endfunction



function! NCIPdebugger_Print(str)
    call setline(s:print_no, a:str)
    let s:print_no = s:print_no + 1
endfunction

function! NCIPdebugger_Strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! NCIPdebugger_GotoBuf(bufnr)
    execute bufwinnr(a:bufnr) . 'wincmd w'
endfunction

function! NCIPdebugger_BuildSymbolTable(opstat)
    let l:opstat_content = readfile(a:opstat)

    for l:line in l:opstat_content
        if match(l:line, '^#') != -1
            let l:name = matchstr(l:line, '[^# {]\+')
            let l:symbol_list = []
            let l:dest = s:macros
        elseif match(l:line, '^@') != -1
            let l:name = matchstr(l:line, '[^@ {]\+')
            let l:symbol_list = []
            let l:dest = s:functions
        elseif match(l:line, '^}') != -1
            let l:dest[l:name] = l:symbol_list
        else
            let l:tmp = split(l:line, ',')
            let l:symbol = {}
            let l:symbol['offset'] = NCIPdebugger_Strip(l:tmp[0])
            let l:symbol['line_no'] = NCIPdebugger_Strip(l:tmp[1])
            let l:symbol['code'] = NCIPdebugger_Strip(l:tmp[2])
            call add(l:symbol_list, l:symbol)
        endif
    endfor
endfunction

function! NCIPdebugger_DumpSymbolTable()
    call NCIPdebugger_Debug('==== Functions ====')
    for [l:f_name, l:f_symbols] in items(s:functions)
        call NCIPdebugger_Debug(l:f_name)
        for l:f_symbol in l:f_symbols
            call NCIPdebugger_Debug('%d,%d,%s', l:f_symbol['offset'], l:f_symbol['line_no'], l:f_symbol['code'])
        endfor
    endfor

    call NCIPdebugger_Debug('==== Macros ====')
    for [l:m_name, l:m_symbols] in items(s:macros)
        call NCIPdebugger_Debug(l:m_name)
        for l:m_symbol in l:m_symbols
            call NCIPdebugger_Debug('%d,%d,%s', l:m_symbol['offset'], l:m_symbol['line_no'], l:m_symbol['code'])
        endfor
    endfor
endfunction

function! NCIPdebugger_Find(f_name, offset)
    let l:symbols = s:functions[a:f_name]
    let l:offset = str2nr(a:offset, 16)
    let s:calling_stack = []
    call add(s:calling_stack, '@' . a:f_name)

    while 1
        for l:symbol in l:symbols
            let l:difference = l:offset - l:symbol['offset']

            if l:difference > 0
                continue
            elseif l:difference < 0
                break
            endif

            while 1
		let s:calling_stack[-1] .= ':' . l:symbol['line_no']

                if match(l:symbol['code'], '^"macro(#[^# {"]\+)"') == -1
                    return l:symbol['line_no']
                endif

                let l:m_name = substitute(l:symbol['code'], '^"macro(#\([^# {"]\+\))".*$', '\1', '')
		" for dummy instruction
		if empty(s:macros[l:m_name])
                    return l:symbol['line_no']
		endif
                let l:symbol = s:macros[l:m_name][0]
		call add(s:calling_stack, '#' . l:m_name)
            endwhile
        endfor

        let l:found = 0
        for l:i in range(len(l:symbols) - 1)
            if l:offset > l:symbols[l:i]['offset'] && l:offset < l:symbols[l:i + 1]['offset']
                let l:offset = l:offset - l:symbols[l:i]['offset']
                if match(l:symbols[l:i]['code'], '^"macro(#[^# {"]\+)"') == -1
                    call NCIPdebugger_Error('NCIPdebugger_Find: should never happen, opstat corrupt? position 1')
                    throw 'NCIPdebugger_Find: should never happen, opstat corrupt?'
                endif

                let l:m_name = substitute(l:symbols[l:i]['code'], '^"macro(#\([^# {"]\+\))".*$', '\1', '')
		let s:calling_stack[-1] .= ':' . l:symbols[l:i]['line_no']
                let l:symbols = s:macros[l:m_name]
		call add(s:calling_stack, '#' . l:m_name)
                let l:found = 1
                break
            endif
        endfor
        if !l:found
            call NCIPdebugger_Error('NCIPdebugger_Find: should never happen, opstat corrupt? position 2')
            throw 'NCIPdebugger_Find: should never happen, opstat corrupt?'
        endif
    endwhile
endfunction

function! NCIPdebugger_Step(direction)
    while 1
        if a:direction == '+'
            let s:current_line_no = s:current_line_no + 1
        else
            let s:current_line_no = s:current_line_no - 1
        endif

        if s:current_line_no < 0
	    echo 'End of Data'
            break
        endif

        let l:line = get(s:log_content, s:current_line_no)
        if l:line == '0'
            echo 'End of Data'
            break
        endif

        if match(l:line, '^[^:]\+::\x\+ - \x\+') == -1
            continue
        endif

        let l:f_name = substitute(l:line, '^\(.*\)::.*$', '\1', '')
        let l:offset = substitute(l:line, '^.*::\(\x\+\) - \(\x\+\).*$', '\2', '')
        let l:result = NCIPdebugger_Find(l:f_name, l:offset)

        execute 'match NCIPdebuggerCurrent /\%' . (s:current_line_no + 1) . 'l/'
        call cursor(s:current_line_no + 1, 1)

	call NCIPdebugger_GotoBuf(s:pattern_bufnr)
        execute 'match NCIPdebuggerCurrent /\%' . l:result . 'l/'
        call cursor(l:result, 1)
        normal zz

	call NCIPdebugger_GotoBuf(s:calling_stack_bufnr)
	set modifiable
	set noreadonly
	execute 'normal ggdG'
	let s:print_no = 1
	call NCIPdebugger_Print('--------Start--------')
	for l:calling in s:calling_stack
	    call NCIPdebugger_Print(l:calling)
	endfor
	call NCIPdebugger_Print('---------End---------')
	set readonly
	set nomodifiable
	set nomodified

	call NCIPdebugger_GotoBuf(s:log_bufnr)

        break
    endwhile
endfunction

function! NCIPdebugger_Next()
    call NCIPdebugger_Step('+')
endfunction

function! NCIPdebugger_Prev()
    call NCIPdebugger_Step('-')
endfunction

function! NCIPdebugger_Jump()
    let s:current_line_no = line('.') - 2
    call NCIPdebugger_Next()
endfunction

function! NCIPdebugger_ReverseFindSymbol(line_no, sources)
    let l:found = 0
    let l:found_name = ''
    let l:results = []

    for [l:name, l:symbols] in items(a:sources)
	for l:symbol in l:symbols
	    if l:symbol['line_no'] == a:line_no
		let l:found_name = l:name
		call add(l:results, l:symbol['offset'])
		let l:found = 1
	    endif
	endfor

	if l:found
	    break
	endif
    endfor

    if l:found
	call NCIPdebugger_Debug('NCIPdebugger_ReverseFindSymbol: find for lineno: "%d", offsets: "%s"', a:line_no, join(l:results, ','))
	return { 'name': l:found_name, 'offsets': results }
    else
	call NCIPdebugger_Debug('NCIPdebugger_ReverseFindSymbol: find for lineno: "%d", not found', a:line_no)
	return {}
    endif
endfunction

function! NCIPdebugger_ReverseFindCaller(macro_name)
    let l:results = []
    let l:pattern = '"macro(#' . a:macro_name . ')"'

    call NCIPdebugger_Debug('NCIPdebugger_ReverseFindCaller: find for pattern: "%s"', l:pattern)

    for [l:name, l:symbols] in items(s:functions)
	for l:symbol in l:symbols
	    if l:symbol['code'] == l:pattern
		call add(l:results, l:symbol['line_no'])
		call NCIPdebugger_Debug('NCIPdebugger_ReverseFindCaller: caller name: "@%s", caller lineno: "%d"', l:name, l:symbol['line_no'])
	    endif
	endfor
    endfor

    for [l:name, l:symbols] in items(s:macros)
	for l:symbol in l:symbols
	    if l:symbol['code'] == l:pattern
		call add(l:results, l:symbol['line_no'])
		call NCIPdebugger_Debug('NCIPdebugger_ReverseFindCaller: caller name: "#%s", caller lineno: "%d"', l:name, l:symbol['line_no'])
	    endif
	endfor
    endfor

    return l:results
endfunction

function! NCIPdebugger_ReverseFind()
    let l:line_no = line('.')
    let l:results = []
    let l:jobs = [{ 'line_no': l:line_no, 'offsets': [0] }]
    let l:f_symbol_cache = {}
    let l:m_symbol_cache = {}
    let l:caller_cache = {}

    while !empty(l:jobs)
	let l:current_job = remove(l:jobs, 0)
	call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: current job line_no: "%d", offsets: "%s"', l:current_job['line_no'], join(l:current_job['offsets'], ','))

	if has_key(l:f_symbol_cache, l:current_job['line_no'])
	    let l:f_rets = get(l:f_symbol_cache, l:current_job['line_no'])
	else
	    let l:f_rets = NCIPdebugger_ReverseFindSymbol(l:current_job['line_no'], s:functions)
	    let l:f_symbol_cache[l:current_job['line_no']] = l:f_rets
	    call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: save cache for line "%d" function symbols', l:current_job['line_no'])
	endif

	if !empty(l:f_rets)
	    let l:working_offsets = []
	    for l:offset in l:f_rets['offsets']
		for l:offset2 in l:current_job['offsets']
		    let l:new_offset = l:offset + l:offset2
		    if index(l:working_offsets, l:new_offset) == -1
			call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: find a new one, derived from line_no: "%d" and function: "%s"', l:current_job['line_no'], l:f_rets['name'])
			call add(l:working_offsets, l:new_offset)
		    endif
		endfor
	    endfor

	    let l:result = { 'name': l:f_rets['name'], 'offsets': l:working_offsets }
	    if index(l:results, l:result) == -1
		call add(l:results, l:result)
	    endif
	    continue
	endif


	call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: cannot find a corresponding function, try to find a macro')


	if has_key(l:m_symbol_cache, l:current_job['line_no'])
	    let l:m_rets = get(l:m_symbol_cache, l:current_job['line_no'])
	else
	    let l:m_rets = NCIPdebugger_ReverseFindSymbol(l:current_job['line_no'], s:macros)
	    let l:m_symbol_cache[l:current_job['line_no']] = l:m_rets
	    call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: save cache for line "%d" macro symbols', l:current_job['line_no'])
	endif

	if !empty(l:m_rets)
	    if has_key(l:caller_cache, l:m_rets['name'])
		let l:c_rets = get(l:caller_cache, l:m_rets['name'])
	    else
		let l:c_rets = NCIPdebugger_ReverseFindCaller(l:m_rets['name'])
		let l:caller_cache[l:m_rets['name']] = l:c_rets
		call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: save cache for macro "%s" callers', l:m_rets['name'])
	    endif

	    if empty(l:c_rets)
		call NCIPdebugger_Error('NCIPdebugger_ReverseFind: should never happen, opstat corrupt? position 3')
		continue
	    endif

	    for l:c_ret in l:c_rets
		for l:offset in l:m_rets['offsets']
		    for l:offset2 in l:current_job['offsets']
			let l:job = { 'line_no': l:c_ret, 'offsets': [l:offset + l:offset2] }
			if index(l:jobs, l:job) == -1
			    call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: add job line_no: "%d", offsets: "%s"', l:c_ret, join(l:job['offsets'], ','))
			    call add(l:jobs, l:job)
			endif
		    endfor
		endfor
	    endfor
	    continue
	endif

	call NCIPdebugger_Error('NCIPdebugger_ReverseFind: should never happen, opstat corrupt? position 4')
    endwhile


    if empty(l:results)
	call NCIPdebugger_Error('NCIPdebugger_ReverseFind: not found')
	echo 'NCIPdebugger_ReverseFind: not found'
	return -1
    endif

    call NCIPdebugger_GotoBuf(s:pattern_bufnr)
    execute '2match NCIPdebuggerReverseCurrent /\%' . l:line_no . 'l/'

    call NCIPdebugger_GotoBuf(s:log_bufnr)
    let l:pattern = 'dummy'
    for l:result in l:results
	for l:offset in l:result['offsets']
	    let l:pattern .= '\|' . printf('%s::.* - .*%06x\/.*$', l:result['name'], l:offset)
	    call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: final result, function_name: "%s" offset: %#06x', l:result['name'], l:offset)
	endfor
    endfor
    call NCIPdebugger_Debug('NCIPdebugger_ReverseFind: match for pattern "%s"', l:pattern)
    execute '2match NCIPdebuggerReverseCurrent /' . l:pattern . '/'
    let g:ReverseFindPattern = l:pattern
endfunction

function! NCIPdebugger_ContinueReverseFind()
    if exists('g:ReverseFindPattern')
	call search(g:ReverseFindPattern, 'w')
    endif
endfunction

function! NCIPdebugger_SyntaxHighlight()
    highlight NCIPdebuggerCurrent term=bold ctermbg=DarkBlue ctermfg=Yellow guibg=DarkBlue guifg=Yellow
    highlight NCIPdebuggerReverseCurrent term=bold ctermbg=DarkRed ctermfg=Yellow guibg=DarkRed guifg=Yellow
endfunction

function! NCIPdebugger_Main()
    if exists('g:NCIPdebugger_Enabled')
	echo 'NCIPdebugger_Main: already launched debugger'
	return -1
    endif

    let s:functions = {}
    let s:macros = {}
    let s:print_no = 1

    let l:opstat = input('Opstat: ', '', 'file')
    if !filereadable(l:opstat)
        throw 'file "' . l:opstat . '" does not exist'
        return -1
    endif

    let l:log = input('Log: ', '', 'file')
    if !filereadable(l:log)
        throw 'file "' . l:log . '" does not exist'
        return -1
    endif

    call NCIPdebugger_BuildSymbolTable(l:opstat)
    "call NCIPdebugger_DumpSymbolTable()

    set number
    set readonly
    set nomodified
    call NCIPdebugger_SyntaxHighlight()
    let s:pattern_bufnr = bufnr('%')

    vnew

    let s:log_content = readfile(l:log)
    let s:print_no = 1
    for l:line in s:log_content
        call NCIPdebugger_Print(l:line)
    endfor
    execute 'file (NCIPdebugger)' . l:log
    set number
    set readonly
    set nomodified
    let s:log_bufnr = bufnr('%')
    let s:current_line_no = -1

    call NCIPdebugger_GotoBuf(s:pattern_bufnr)
    10new
    wincmd r
    file '(NCIPdebugger)calling_stack'
    set number
    set readonly
    set nomodified
    set nomodifiable
    let s:calling_stack_bufnr = bufnr('%')

    call NCIPdebugger_GotoBuf(s:pattern_bufnr)
    nnoremap <buffer> <silent> <F6> :call NCIPdebugger_ReverseFind()<CR>
    set nomodifiable

    call NCIPdebugger_GotoBuf(s:log_bufnr)
    set nomodifiable

    nnoremap <buffer> <silent> <F3> :call NCIPdebugger_Next()<CR>
    nnoremap <buffer> <silent> <F4> :call NCIPdebugger_Prev()<CR>
    nnoremap <buffer> <silent> <F5> :call NCIPdebugger_Jump()<CR>
    nnoremap <buffer> <silent> <F6> :call NCIPdebugger_ContinueReverseFind()<CR>
    nnoremap <buffer> <silent> <C-Down> :call NCIPdebugger_Next()<CR>
    nnoremap <buffer> <silent> <C-Up> :call NCIPdebugger_Prev()<CR>

    let g:NCIPdebugger_Enabled = 1
    redraw!
endfunction

nnoremap <silent> <F2> :call NCIPdebugger_Main()<CR>
