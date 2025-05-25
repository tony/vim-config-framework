" JSON and JSON5 file detection
autocmd BufRead,BufNewFile *.json set filetype=json
autocmd BufRead,BufNewFile tsconfig.json set filetype=json5
autocmd BufRead,BufNewFile api-extractor.json set filetype=json5

" JSON configuration files that should be treated as JavaScript
autocmd BufNewFile,BufRead .bowerrc,.jshintrc,.watchmanconfig set filetype=javascript