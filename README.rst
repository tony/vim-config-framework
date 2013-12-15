Detailed VIM configuration
==========================

Modularized VIM Configuration
-----------------------------

Modularization of vim configuration is based off 3 aspects:

- Splitting config separate files (see ``unite.vim`` is separate from
  ``.vimrc``.

  Inside of ``.vimrc``, I will do:

  .. code-block:: VimL

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

.. code-block:: VimL

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

.. _gmarik: https://github.com/gmarik/
.. _tpope: https://github.com/tpope/
.. _Shougu: https://github.com/Shougu/

.. _git submodules: http://git-scm.com/docs/git-submodule

.. _Pathogen: https://github.com/tpope/vim-pathogen
.. _Vundle: https://github.com/gmarik/vundle
.. _neobundle.vim: https://github.com/Shougo/neobundle.vim

.. _vimball: http://www.vim.org/scripts/script.php?script_id=1502
.. _vim.org's script repository: http://www.vim.org/scripts/

.. _Learn Vimscript the Hard Way: http://learnvimscriptthehardway.stevelosh.com/chapters/42.html
