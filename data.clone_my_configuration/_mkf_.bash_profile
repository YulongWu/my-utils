# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

source ~/.profile

#PATH=$PATH:$HOME/.local/bin
export PATH
export SHELL=/home/wuyulong/zsh/bin/zsh
exec /home/wuyulong/zsh/bin/zsh -l
