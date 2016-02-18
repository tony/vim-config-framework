Bundles
=======

Any file in this directory with ``.vim`` as a file extension will be
sourced.  You can run ``NeoBundle`` and ``NeoBundleLazy`` from here.

How to add your bundles
-----------------------

You can separate your bundles out however you choose. Anything in this
directory ``.vim`` gets ran. For the sake of example, lets just create
a file called ``nerdtree.vim`` here::

    vim nerdtree.vim

In our ``nerdtree.vim``:

.. code-block:: viml

    NeoBundleLazy 'scrooloose/nerdtree', {
      \ 'autoload' : {
      \    'commands': ['NERDTreeToggle', 'NERDTree', 'NERDTreeClose']
      \  }
      \}

Even better, let's add `nerdtree-git-plugin`_ and only source it if
``git`` exists.

.. code-block:: viml

    NeoBundleLazy 'Xuyuanp/nerdtree-git-plugin', {
      \   "autoload" : {
      \       "commands" : ["NERDTreeToggle", "NERDTree", "NERDTreeClose"]
      \   },
      \   "external_commands": "git"
      \}

.. _nerdtree-git-plugin: https://github.com/Xuyuanp/nerdtree-git-plugin

Community NeoBundle Configs
---------------------------

``./avail/`` contains curated bundles. You can symlink the configs to this
directory to use them::

    cd avail
    ln -sf avail/mypackage.vim mypackage.vim

Advantages:

1. (Some packages) only install the bundle if a certain command is present in the
   system ``PATH``.

   e.g. It will only install vim-go if go is installed.

   You will be able to use the same config on multiple machines, and the
   config will in many cases only install necessary packages.

2. (Some packages) only add bundles to ``rtp`` / activate upon loading a
   buffer of a certain ``filetype``.

3. It prevents merge conflicts from pulling upstream changes from this
   repository.

4. It encourages communally improving the ``NeoBundle`` configs for the
   plugins so they work better across platforms.

**What if I want to to use the community package via symlink and my own also?**

Symlink the file as normal, keep customizations in a file ending with ``_`` before
the ``.extension``.

So if you symlinked ``avail/coolpackage.vim`` to this directory as ``coolpackage.vim``
keep your  specialized settings in ``coolpackage_.vim``. Which would give you::

    ./
    | avail/
    | | 
    | \- coolpackage.vim
    | coolpackage.vim (symlink to avail/coolpackage.vim)
    | coolpackage_.vim (your custom stuff)
