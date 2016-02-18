Features available
------------------

- `neocompleteme`_ for autocompletion
- Python: jedi completion, linting and tools via ``klen/python-mode``
- C / C++ / Objective C: YouCompleteMe autocompletion and color_coded
  syntax highlighting
- Golang: Go autocomplete and automated ``gofmt``
- Node.js / JS: Tern completion
- LaTeX: `LaTeX-Box`_
- reStructuredText: Rykka/riv.vim
- Automated sourcing of ``~/.vimrc.local`` and the rest of `spf13`_'s
  hooks.
  
None of the above language-specific plugins will be installed if you don't
have the compiler / interpreter on your system.

Environmental Variables
-----------------------

``BASE16_SCHEME`` - The name of your base16 theme.

Colorscheme on TTY's
--------------------

``color.vim`` is set to check for a ``TTY`` environmental variable. Add
this to your shell variables::

    export TTY=$(tty)

Overview
--------

=================== ======================================================
File                Contents
=================== ======================================================
``.vimrc``          Move to ``$HOME/.vimrc`` in POSIX. In other os see the
                    `vim wiki`_ page on `vimrc`_ files.
------------------- ------------------------------------------------------
``bundles.vim``     Manifest of packages to install.

                    Automatically installs `neobundle.vim`_ via git if it
                    doesn't exist.
------------------- ------------------------------------------------------
``keymappings.vim`` Keybindings all in one location.
------------------- ------------------------------------------------------
``functions.vim``   Misc. vim functions.
------------------- ------------------------------------------------------
``colors.vim``      Color scheme, highlighting.
------------------- ------------------------------------------------------
``autocmd.vim``     Language-specific conditions, indentation, vim
                    settings.
------------------- ------------------------------------------------------
``ignore.vim``      Ignore file regex's for various plugins.
------------------- ------------------------------------------------------
``settings.vim``    Global vim settings
------------------- ------------------------------------------------------
``sensible.vim``    tpope's sensible vim defaults
=================== ======================================================


Keymappings / Shortcuts
-----------------------

See `keymappings.vim`_ for more.

=========================== ===============================================
Keybinding                  Action
=========================== ===============================================
``<leader>``                Is ``,``. Used before any shortcut with
                            ``<leader>``.
--------------------------- -----------------------------------------------
``<leader> <tab>``          Toggle File Tree.
--------------------------- -----------------------------------------------
``<leader> 2``              Open source code tags (classes, methods,
                            functions).
--------------------------- -----------------------------------------------
``<leader> 4``              Toggle paste
--------------------------- -----------------------------------------------
``<leader> 6``              Toggle relative line numbers.
--------------------------- -----------------------------------------------
``<leader> 7``              Toggle *all* line numbers.
--------------------------- -----------------------------------------------
``<leader> f``              Indent all code in buffer ``gg=G``
--------------------------- -----------------------------------------------
``<leader> g``              Go to Implementation or Declaration (split)
--------------------------- -----------------------------------------------
``<leader> d``              Delete window + go to previous buffer
--------------------------- -----------------------------------------------
``<space>``                 `unite.vim`_ leader key.
--------------------------- -----------------------------------------------
``<space> + <space>``       Launch unite with Buffers, files.
--------------------------- -----------------------------------------------
``<space> + g``             Grep (file contents) in current file.
--------------------------- -----------------------------------------------
``<space> + G``             Grep (find inside file) all files in CWD.
--------------------------- -----------------------------------------------
``<space> + n``             Find files relative to ``CWD`` by file name.
--------------------------- -----------------------------------------------
``<space> + m``             Most recent files
--------------------------- -----------------------------------------------
``<space> + o``             Search tags (class, methods, functions) in
                            current buffer.
--------------------------- -----------------------------------------------
``ctrl-h/j/k/l``            Move between window panes
--------------------------- -----------------------------------------------
``q`` or ``ctrl-c``
(inside file tree,          Close pane
tagbar or unite)
--------------------------- -----------------------------------------------
``;[`` / ``<leader>[``      Cycle backwards through buffers (previous)
--------------------------- -----------------------------------------------
``;]`` / ``<leader>]``      Cycle forward through buffers (next)
--------------------------- -----------------------------------------------
``ctrl-i``                  `CtrlP`_ prompt
=========================== ===============================================

.. _keymappings.vim: https://github.com/tony/vim-config/blob/master/settings/contrib/keymappings.vim
.. _neocompleteme: https://github.com/Shougo/neocompleteme.vim
.. _LaTeX-Box: https://github.com/LaTeX-Box-Team/LaTeX-Box

