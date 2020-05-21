#!/bin/zsh
export CODE_HOME="$HOME/Code"
export BOOTSTRAP_HOME="$CODE_HOME/bootstrap"
export DOTFILES_HOME="$CODE_HOME/dotfiles"
export DOTFILES_PRIVATE_HOME="$DOTFILES_HOME/dotfiles_private"


# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew install the rest of the packages
cd $BOOTSTRAP_HOME/bootstrap_home
brew bundle

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# link all dotfiles
if [[ ! -d $DOTFILES_HOME/dotfiles_home ]]; then
	git clone git@github.com:feynlee/dotfiles.git ~/Code/dotfiles/dotfiles_home
fi

if [[ ! -d $DOTFILES_HOME/dotfiles_tools_li ]]; then
	git clone git@github.com:feynlee/dotfiles_tools_li.git ~/Code/dotfiles/dotfiles_tools_li
fi

if [[ ! -d $DOTFILES_PRIVATE_HOME ]]; then
	echo "$DOTFILES_PRIVATE_HOME! Please get dotfiles_private before executing bootstrap.sh."
	exit 1
fi

rm -rf ~/.ssh
rm -rf ~/.zshrc
cd $DOTFILES_HOME/dotfiles_private && stow -R -v -t ~ .
cd $DOTFILES_HOME/dotfiles_tools_li && git pull && stow -R -v -t ~ .
cd $DOTFILES_HOME/dotfiles_home && git pull && stow -R -v -t ~ .
. ~/.bash_profile
. ~/.zprofile

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
if [[ ! -f ~/Downloads/anaconda3.sh ]]; then
	wget https://repo.anaconda.com/archive/Anaconda3-2020.02-MacOSX-x86_64.sh -O ~/Downloads/anaconda3.sh
fi
/bin/bash ~/Downloads/anaconda3.sh -b -p -u /Applications/Anaconda3
rm ~/Downloads/anaconda3.sh
source /Applications/Anaconda3/bin/activate
conda init
conda config --set auto_activate_base True

# use conda to install all python packages
conda install -y nb_conda_kernels
conda env create -y -f py37.yml
conda install -y pyspark
# install notebook extensions
pip install --upgrade pip
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user

# install spark
# wget -O

echo "==> All done!"
