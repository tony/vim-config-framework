#!/bin/bash
#

mkdir ~/.vim/bundle
git clone http://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle

vim +BundleInstall +qall

# writing the state line
echo  # an empty line here so the next line will be the last.
echo "changed=yes comment='something's changed!' whatever=123"
