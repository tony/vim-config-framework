vint:
	python -c 'import vint' || pip install --user vim-vint
	vint *.vim

nvim:
	ln -s ~/.vim/autoload ~/.config/nvim/autoload
