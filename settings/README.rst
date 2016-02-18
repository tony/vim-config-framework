General VIM settings
====================

Any file with ``.vim`` inside of here will be loaded when vim starts.

Add your own settings
---------------------

Create any file, as long as it ends with ``.vim`` as a file extension.

.. code-block:: sh

    vim colors.vim

Inside ``colors.vim`` (file name doesn't matter, its just for your organization)

.. code-block:: viml

    colorscheme desert

Next time to start up your colorscheme will be desert. Of course, see ``contrib/`` for more complicated settings designed to work across machines with a variety stacks.

Community Settings
------------------

``./contrib/`` contains configs you can copy settings from if you wish.

Files in ``./contrib/`` are able to receive upstream `pull requests`_. The intent for them is to work across platforms and machines and degrade gracefully if features are not available.

You can **symbolic link** them from ``contrib/filename.vim`` to this directory.
The benefits to this is you can merge the latest settings to your configuration.

For instance:

.. code-block:: sh

    cd settings
    ln -sf contrib/sensible.vim sensible.vim

Symlinks sensible.vim (tpope's `vim-sensible`_ defaults)

.. _vim-sensible: https://github.com/tpope/vim-sensible 

Another option is to simply copy and paste what you find useful in ``contrib/`` to
a new file in this directory.

Go into a file like ``contrib/colors.vim``, copy out a chunk, and put it into a new file in this directory.

.. _pull requests: https://help.github.com/articles/using-pull-requests/
