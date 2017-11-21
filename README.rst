==========================================================================
Minimalist, modular, commented, lazy-loading vim / neovim config framework
==========================================================================

The major difficulties with dot vim configurations is they become
too complex to debug, make too many opinions and are unfriendly to merging
upstream changes.

Just looking for snippets? Feel free to check out `my vim snippets
<https://devel.tech/snippets/topic/vim/>`_ on my new site `devel.tech
<https://devel.tech>`_.

Installation
------------

.. code-block:: console

    $ mv ~/.vim ~/.vim-backup
    $ git clone https://github.com/tony/vim-config-framework ~/.vim
    $ cd ~/.vim && make complete

    # open vim
    $ vim

    # inside vim (there may be an error, just press enter)
    :PlugInstall
    :q!  # quit

    # open vim again
    $ vim

Minimalist defaults
-------------------

The config scans all files with ``.vim`` extension in the first **first level**
of these directories:

- *settings/* - vim settings

(So, if you add a file ``settings/hiworld.vim``, it will always be loaded.)

*Optionally*, if you want package management:

- *plugins.vim* - `Plug`_ package declarations
- *plugins.settings/* - plugin settings

Declare your packages/bundles in *plugins.vim*, Plug will be
installed on your behalf, as well as all ``Plug`` packages in
*plugins.vim*.

Community bundle declarations and settings
------------------------------------------

- *settings/contrib/*
- *plugins.settings/contrib/*

are community settings you can decide to symbolic link or copy into your
personal settings in *settings/\*.vim*, and
*plugins.settings/\*.vim* as you choose.

The added benefit is these Plug declarations, bundle settings and
bundles are designed to degrade gracefully, lazily load depending on
the system stack, etc. Pull requests are welcome to keep these continually
improved, but they are *entirely optional*.

- Put all your bundle (addons you want to install and use in 
  *plugins.vim* (name any file you'd like) and it gets scanned in.
  or customize yourself manually. See *plugins.d/README.rst* for more.
- Lazy-loading vim plugins via `Plug`_.
- Lazy-loading vim plugins via checking your systems stack 
- Lazy-loading of plugin settings via *plugins.settings*.
- Automated compilation of plugins (partial)

Customization
-------------

Hooks / Files
~~~~~~~~~~~~~

These conventions are derived from `spf13`_. In order of sourcing:

- *~/.vimrc.before* - ran before config
- *~/.vimrc.local*
- *~/.gvimrc.local* - only for gtk

Thanks
------

- https://github.com/spf13/spf13-vim (Apache 2.0 license)
- https://github.com/jpalardy/dotfiles (MIT license) for ``Preserve``
- see other thanks in the comments inside.

.. _gmarik: https://github.com/gmarik/
.. _tpope: https://github.com/tpope/

.. _Plug: https://github.com/junegunn/vim-plug

.. _vimrc: http://vim.wikia.com/wiki/Open_vimrc_file
.. _spf13: https://github.com/spf13/spf13-vim

License
-------

MIT

Vendorizes sensible.vim, see `license permission`_.

.. _license permission: https://github.com/tpope/vim-sensible/issues/106
