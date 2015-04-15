You can customize this vim config by forking it. Local modifications can
be done via ``~/.vimrc.local``.This

Features:

- Lazy-loading vim plugins via NeoBundle
- Lazy-loading vim plugins via checking for system binary (php, node,
  scala, go, python).
- Lazy-loading of plugin settings via ``neobundle#tap`` and
  ``neobundle#hooks.on_post_source``.
- Automated compilation of plugins (partial)
- Python: jedi completion, linting and tools via ``klen/python-mode``
- C / C++ / Objective C: YouCompleteMe autocompletion and color_coded
  syntax highlighting
- Golang: Go autocomplete and automated ``gofmt``
- Node.js / JS: Tern completion
- LaTeX: `LaTeX-Box`_
- reStructuredText: Rykka/riv.vim
- Automated sourcing of ``~/.vimrc.local`` if exists.
  
None of the above language-specific plugins will be installed if you don't
have the compiler / interpreter on your system.

.. _LaTeX-Box: https://github.com/LaTeX-Box-Team/LaTeX-Box

Modularized VIM Configuration
-----------------------------

=================== ======================================================
File                Contents
=================== ======================================================
``.vimrc``          Move to ``$HOME/.vimrc`` in POSIX. In other os see the
                    `vim wiki`_ page on `vimrc`_ files.
------------------- ------------------------------------------------------
``bundles.vim```    Manifest of packages to install.

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
``settings/*.vim``  Settings for individual plugins.
------------------- ------------------------------------------------------
``unite.vim``       `unite.vim`_ config settings.
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
``ctrl-x``                  Explore files from CWD
--------------------------- -----------------------------------------------
``ctrl-c``                  Delete buffer (close file) go to last file
                            a.k.a ``:BB``.
--------------------------- -----------------------------------------------
``;[``                      Cycle backwards through buffers (previous)
--------------------------- -----------------------------------------------
``;]``                      Cycle forward through buffers (next)
--------------------------- -----------------------------------------------
``ctrl-i``                  `CtrlP`_ prompt
--------------------------- -----------------------------------------------
 (visual)``<leader>-z``     Find and replace based upon selection
=========================== ===============================================

.. _keymappings.vim: https://github.com/tony/vim-config/blob/master/keymappings.vim

Vim config best practice
------------------------

Modularization and decopling of vim configuration is based off 3 aspects:

- Splitting config separate files (see ``unite.vim`` is separate from
  ``.vimrc``.

  Inside of ``.vimrc``, I will do:

  .. code-block:: vim

      source ~/.vim/bundles.vim

- Plugin management

  Automatically download and update vim plugins.

  The history of vim configurations publicly speaking is based off
  observable practice, this is my best recollection of how plugin
  management has evolved over the recent years:
  
  In the beginning, vimscripts would be kept inside of the ``~/.vim/``
  directory. `Learn Vimscript the Hard Way`_ describes the layout
  stucture::

      ~/.vim/colors/
      ~/.vim/plugin/
      ~/.vim/ftdetect/
      ~/.vim/ftplugin/
      ~/.vim/indent/
      ~/.vim/compiler/
      ~/.vim/after/
      ~/.vim/autoload/
      ~/.vim/doc/
  
  Then there were `vimball`_ installers.
  
  Then `Pathogen`_ would allow loading packages via custom  directries,
  and the best practice would change to storing plugins in ``./bundle``.
  Clever people would begin to use `Pathogen`_ with `git submodules`_ as a
  way to keep multiple packages in sync.

  Today, most vim plugins reside on github repositories as opposed to
  `vim.org's script repository`_. `Vundle`_ and `NeoBundle`_ come in
  excellently here, since they install, update and load.
- VCS to manage changes / store vim config

  This vimrc is managed in a git repository. It serves as a way to
  make sure different machines can have a synchronized configurations,
  changes can be logged and most importantly, there is a backup.

VIM plugin manager
------------------

`Shougu`_/`neobundle.vim` is used for packagement. Advantages include
support for asynchronous updating, etc.

Alternatives are `gmarik`_/`Vundle`_ and `tpope`_/`Pathogen`_.

Install Neobundle automatically
"""""""""""""""""""""""""""""""

.. code-block:: vim

    set nocompatible
    filetype off

    " Setting up Vundle - the vim plugin bundler
    " Credit: http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
    let iCanHazVundle=1
    let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
    if !filereadable(neobundle_readme)
        echo "Installing neobundle.vim."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
        let iCanHazVundle=0
    endif

    set rtp+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))

    " Let NeoBundle manage NeoBundle
    NeoBundleFetch 'Shougo/neobundle.vim'

Speed up Unite Grep
-------------------

https://github.com/ggreer/the_silver_searcher for directions on
installation.

For Ubuntu: 

.. code-block:: sh

    $ apt-get install software-properties-common  # (if required)
    $ apt-add-repository ppa:mizuno-as/silversearcher-ag
    $ apt-get update
    $ apt-get install silversearcher-ag

.. _gmarik: https://github.com/gmarik/
.. _tpope: https://github.com/tpope/
.. _Shougu: https://github.com/Shougu/

.. _git submodules: http://git-scm.com/docs/git-submodule

.. _Pathogen: https://github.com/tpope/vim-pathogen
.. _Vundle: https://github.com/gmarik/vundle
.. _neobundle.vim: https://github.com/Shougo/neobundle.vim
.. _NeoBundle: https://github.com/Shougo/neobundle.vim

.. _vimball: http://www.vim.org/scripts/script.php?script_id=1502
.. _vim.org's script repository: http://www.vim.org/scripts/

.. _Learn Vimscript the Hard Way: http://learnvimscriptthehardway.stevelosh.com/chapters/42.html

.. _vim wiki: http://vim.wikia.com/wiki/
.. _vimrc: http://vim.wikia.com/wiki/Open_vimrc_file
.. _unite.vim: https://github.com/Shougo/unite.vim
.. _CtrlP: https://github.com/kien/ctrlp.vim
   
License
-------

MIT
