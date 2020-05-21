#!/bin/bash
export CODE_HOME="$HOME/Code"
export BOOTSTRAP_HOME="$CODE_HOME/bootstrap"
export DOTFILES_HOME="$CODE_HOME/dotfiles"
export DOTFILES_PRIVATE_HOME="$DOTFILES_HOME/dotfiles_private"


# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew install the rest of the packages
cd $BOOTSTRAP_HOME
brew bundle
source ~/.bash_profile

# link all dotfiles
if [[ ! -d $DOTFILES_HOME/dotfiles_home ]]; then
	git clone git@github.com:feynlee/dotfiles.git ~/Code/dotfiles/dotfiles_home
fi

if [[ ! -d $DOTFILES_HOME/dotfiles_private ]]; then
	git clone git@github.com:feynlee/dotfiles_tools_li.git ~/Code/dotfiles/dotfiles_tools_li
fi

if [[ ! -d $DOTFILES_PRIVATE_HOME ]]; then
	echo "$DOTFILES_PRIVATE_HOME! Please get dotfiles_private before executing bootstrap.sh."
	exit 1
fi

rm -rf ~/.ssh
cd $DOTFILES_HOME/dotfiles_private && stow -R -v -t . && git pull

cd $DOTFILES_HOME/dotfiles_home && stow -R -v -t . && git pull
cd $DOTFILES_HOME/dotfiles_tools_li && stow -R -v -t . && git pull
. ~/.bash_profile


# setup Vundle for vim
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# install plugins via vim + vundle
# vim +PluginInstall +qall
# compile ycm (this has to happen before brew installs python,
# so that it's using the correctly linked system python)
# cd ~/.vim/bundle/YouCompleteMe
# ./install.py
# install airline fonts
cd ~
git clone https://github.com/powerline/fonts.git --depth=1
cd ~/fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts


# install anaconda
if [[ ! -f ~/anaconda3.sh ]]; then
	cd ~
	wget https://repo.continuum.io/archive/Anaconda3-5.1.0-MacOSX-x86_64.sh -O ~/anaconda3.sh
	bash ~/anaconda3.sh -b -p /Applications/Anaconda3
	rm ~/anaconda3.sh
fi
# export PATH="Applications/anaconda3/bin:$PATH" >> ~/.bashrc
# use conda to install all python packages
conda install -y nb_conda_kernels
conda env create -f $DOTFILES_HOME/py37.yml
conda install pyspark
# install notebook extensions
pip install --upgrade pip
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user

# install spark
# wget -O



echo "==> All done!"
