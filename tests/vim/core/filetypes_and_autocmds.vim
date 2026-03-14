function! Test_detects_template_filetypes() abort
  let l:root = VimTestTempDir('filetypes')

  call VimTestWriteFile(l:root . '/view.jinja', ['{{ value }}'])
  call VimTestAssertFiletype(l:root . '/view.jinja', 'jinja.html')

  call VimTestWriteFile(l:root . '/view.jinja2', ['{{ value }}'])
  call VimTestAssertFiletype(l:root . '/view.jinja2', 'jinja.html')

  call VimTestWriteFile(l:root . '/component.handlebars', ['{{ value }}'])
  call VimTestAssertFiletype(l:root . '/component.handlebars', 'html.mustache')

  call VimTestWriteFile(l:root . '/component.js.php', ['<?php ?>'])
  call VimTestAssertFiletype(l:root . '/component.js.php', 'javascript')

  call VimTestWriteFile(l:root . '/template.py_tmpl', ['print("hello")'])
  call VimTestAssertFiletype(l:root . '/template.py_tmpl', 'python')
endfunction

function! Test_applies_language_local_settings() abort
  let l:root = VimTestTempDir('language-settings')

  call VimTestWriteFile(l:root . '/app.ts', ['const value = 1'])
  call VimTestOpen(l:root . '/app.ts')
  call assert_equal('typescript', &filetype)
  call assert_equal(2, &l:shiftwidth)
  call assert_equal(2, &l:tabstop)
  call assert_equal(2, &l:softtabstop)
  call assert_true(&l:expandtab)
  call assert_equal(['.git', 'package-lock.json', 'yarn.lock'], b:coc_root_patterns)
  bwipe!

  call VimTestWriteFile(l:root . '/main.go', ['package main'])
  call VimTestOpen(l:root . '/main.go')
  call assert_equal('go', &filetype)
  call assert_equal(4, &l:shiftwidth)
  call assert_equal(8, &l:tabstop)
  call assert_equal(4, &l:softtabstop)
  call assert_true(&l:expandtab)
  bwipe!

  call VimTestWriteFile(l:root . '/config.yaml', ['key: value'])
  call VimTestOpen(l:root . '/config.yaml')
  call assert_equal('yaml', &filetype)
  call assert_equal(2, &l:shiftwidth)
  call assert_equal(8, &l:tabstop)
  call assert_equal(2, &l:softtabstop)
  call assert_true(&l:expandtab)
  bwipe!

  call VimTestWriteFile(l:root . '/plugin.vim', ['set number'])
  call VimTestOpen(l:root . '/plugin.vim')
  call assert_equal('vim', &filetype)
  call assert_equal(':help', &l:keywordprg)
  bwipe!
endfunction
