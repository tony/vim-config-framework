==========================================================================
Minimalist, modular, commented, lazy-loading vim / neovim config framework
==========================================================================

The major difficulties with dot vim configurations is they become
too complex to debug, make too many opinions and are unfriendly to merging
upstream changes.

Minimalist defaults
-------------------

The config scans all files with ``.vim`` extension in the first **first level**
of these directories:

- ``settings/`` - vim settings

(So, if you add a file ``settings/hiworld.vim``, it will always be loaded.)

*Optionally*, if you want package management:

- ``bundles.d/`` - `Plug`_ package declarations
- ``bundles.settings/`` - plugin settings

If you have a file ending with ``.vim`` in bundles.d, Plug will be
installed on your behalf, as well as all ``Plug`` packages in
``bundles.d``.

Community bundle declarations and settings
------------------------------------------

- ``settings/contrib/``
- ``bundles.d/contrib/``
- ``bundles.settings/contrib/``

are community settings you can decide to symbolic link or copy into your
personal settings in ``settings/*.vim``, ``bundles.d/*.vim`` and
``bundles.settings/*.vim`` as you choose.

The added benefit is these Plug declarations, bundle settings and
bundles are designed to degrade gracefully, lazily load depending on
the system stack, etc. Pull requests are welcome to keep these continually
improved, but they are *entirely optional*.

- Put all your bundle (addons you want to install and use in 
  ``bundles.d/*.vim`` (name any file you'd like) and it gets scanned in.
- Put all your settings files in ``settings/*.vim`` (name any file you'd
  like) and it gets scanned in.
- Symlink community bundle configs from ``bundles.d/contrib/`` to ``contrib/``,
  or customize yourself manually. See ``bundles.d/README.rst`` for more.
- Lazy-loading vim plugins via `Plug`_.
- Lazy-loading vim plugins via checking your systems stack 
- Lazy-loading of plugin settings via ``bundles.settings``.
- Automated compilation of plugins (partial)

Customization
-------------

Hooks / Files
~~~~~~~~~~~~~

These conventions are derived from `spf13`_. In order of sourcing:

- ``~/.vimrc.before`` - ran before config
- ``~/.vimrc.fork``
- ``~/.vimrc.local``
- ``~/.gvimrc.local`` - only for gtk

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
