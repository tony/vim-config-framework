vint:
	python -c 'import vint' || pip install --user vim-vint
	vint *.vim

nvim:
	ln -sf ~/.vim/autoload/ ~/.config/nvim/
	ln -sf ~/.vim/.vimrc ~/.config/nvim/init.vim
	ln -sf ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json

complete:
	ln -sf ~/.vim/plugins.settings/contrib/*.vim ~/.vim/plugins.settings/
	ln -sf ~/.vim/settings/contrib/*.vim ~/.vim/settings/
