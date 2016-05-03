vint:
	python -c 'import vint' || pip install --user vim-vint
	vint *.vim

nvim:
	ln -s ~/.vim/autoload ~/.config/nvim/autoload

complete:
	ln -sf ~/.vim/plugins.d/contrib/*.vim ~/.vim/plugins.d/
	ln -sf ~/.vim/plugins.settings/contrib/*.vim ~/.vim/plugins.settings/
	ln -sf ~/.vim/settings/contrib/*.vim ~/.vim/settings/
