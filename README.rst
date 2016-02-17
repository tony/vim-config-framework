==========================================================================
Minimalist, modular, commented, lazy-loading vim / neovim config framework
==========================================================================

Minimalist defaults
-------------------

By default this configuration scans all files with the ``.vim`` extension in
the first **first level** of three directories:

- ``settings/`` - vim settings

*Optionally*, if you want package management:

- ``bundles.d/`` - `NeoBundle`_ package declarations
- ``bundles.settings/`` - plugin settings

So: if you add a file ``settings/hiworld.vim``, it will always be loaded.

Community bundle declarations and settings
------------------------------------------

- ``settings/avail``
- ``bundles.d/avail``
- ``bundles.settings/avail``

are community settings you can decide to symbolic link or copy into your
personal settings in ``settings/*.vim``, ``bundles.d/*.vim`` and
``bundles.settings/*.vim`` as you choose.

The added benefit is these NeoBundle declarations, bundle settings and 
bundles are designed to degrade gracefully, lazily load depending on
the system stack, etc. Pull requests are welcome to keep these continually
improved, but they are *entirely optional*.

- Put all your bundle (addons you want to install and use in 
  ``bundles.d/*.vim`` (name any file you'd like) and it gets scanned in.
- Put all your settings files in ``settings/*.vim`` (name any file you'd
  like) and it gets scanned in.
- Symlink community bundle configs from ``bundles.d/avail`` to ``avail``,
  or customize yourself manually. See ``bundles.d/README.rst`` for more.
- Lazy-loading vim plugins via `NeoBundle`_.
- Lazy-loading vim plugins via checking your systems stack 
- Lazy-loading of plugin settings via ``neobundle#tap`` and
  ``neobundle#hooks.on_post_source``.
- Automated compilation of plugins (partial)
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

.. _NeoBundle: https://github.com/Shougo/neobundle.vim
.. _neocompleteme: https://github.com/Shougo/neocompleteme.vim
.. _LaTeX-Box: https://github.com/LaTeX-Box-Team/LaTeX-Box

Customization
-------------

Hooks / Files
~~~~~~~~~~~~~

These conventions are derived from `spf13`_. In order of sourcing:

- ``~/.vimrc.before`` - ran before config
- ``~/.vimrc.fork``
- ``~/.vimrc.local``
- ``~/.gvimrc.local`` - only for gtk

Environmental Variables
~~~~~~~~~~~~~~~~~~~~~~~

``BASE16_SCHEME`` - The name of your base16 theme.

Colorscheme on TTY's
--------------------

``color.vim`` is set to check for a ``TTY`` environmental variable. Add
this to your shell variables::

    export TTY=$(tty)

Thanks
------

- https://github.com/spf13/spf13-vim (Apache 2.0 license)
- https://github.com/jpalardy/dotfiles (MIT license) for ``Preserve``
- see other thanks in the comments inside.

.. _gmarik: https://github.com/gmarik/
.. _tpope: https://github.com/tpope/

.. _NeoBundle: https://github.com/Shougo/neobundle.vim

.. _vimrc: http://vim.wikia.com/wiki/Open_vimrc_file
.. _spf13: https://github.com/spf13/spf13-vim

License
-------

MIT
