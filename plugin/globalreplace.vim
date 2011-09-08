function! QuickfixFilenames()
	" Building a hash ensures we get each buffer only once
	let buffer_numbers = {}
	for quickfix_item in getqflist()
		let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
	endfor
	return join(values(buffer_numbers))
endfunction
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()

function! GlobalReplace()
	" Assumes Vim is started at the root of your project.
	" Asks for a word that is to be replaced across all files
	" in the current directory and below.
	let wordToRename = input("What should be replaced? ")
	if wordToRename == ''
		echo "Nothing to replace"
		return
	endif

	try
		exec "vimgrep /" . wordToRename . "/ **"
		let toReplaceWith = input("Replace it with? ")
		exec "Qargs"
		exec "argdo %s/" . wordToRename . "/" . toReplaceWith ."/g"
		exec "argdo update"
	catch
		echo "Can't find " . wordToRename
	endtry
endfunction


" create the command GlobalReplace
command! GlobalReplace call GlobalReplace()
