vint:
	python -c 'import vint' || pip install --user vim-vint
	vint *.vim

nvim:
	ln -s ~/.vim/autoload ~/.config/nvim/autoload

complete:
	ln -sf ~/.vim/bundles.d/contrib/*.vim ~/.vim/bundles.d/
	ln -sf ~/.vim/bundles.settings/contrib/*.vim ~/.vim/bundles.settings/
	ln -sf ~/.vim/settings/contrib/*.vim ~/.vim/settings/
