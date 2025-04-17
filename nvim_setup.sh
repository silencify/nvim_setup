#!/bin/bash

if ! command -v git &> /dev/null; then
  echo "Git install start"
  sudo apt-get -y install git
  echo "Git install end"
fi

if ! command -v curl &> /dev/null; then
  echo "Curl install start"
  sudo apt-get -y install curl
  echo "Curl install success"
fi

if ! command -v nvim &> /dev/null; then
  NVIM_ARCHIVE_FILE=nvim-linux-x86_64.tar.gz
  NVIM_VERSION=v0.10.4

  echo "Neovim $NVIM_VERSION install start"
  curl -O --output-dir $HOME -L https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$NVIM_ARCHIVE_FILE
  tar -xzf $HOME/$NVIM_ARCHIVE_FILE -C $HOME
  sudo mv $HOME/nvim-linux-x86_64 /opt/nvim
  sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm $HOME/$NVIM_ARCHIVE_FILE
  echo "Neovim $NVIM_VERSION install success"
fi

if ! command -v unzip &> /dev/null; then
  echo "Unzip install start"
  sudo apt-get -y install unzip
  echo "Unzip install success"
fi

if ! command -v rg &> /dev/null; then
  echo "Ripgrep install start"
  sudo apt-get -y install ripgrep
  echo "Ripgrep install success"
fi

if ! command -v xclip &> /dev/null; then
  echo "Xclip install start"
  sudo apt-get -y install xclip
  echo "Xclip install success"
fi

if ! command -v pipx &> /dev/null; then
  echo "Pipx install start"
  sudo apt-get -y install pipx 
  echo "Pipx install success"
fi

if ! command -v pip &> /dev/null; then
  echo "Pip install start"
  sudo apt-get -y install python3-pip
  echo "Pip install success"
fi

if ! pip show python-lsp-server &> /dev/null; then
  echo "Python-lsp-server install start"
  pipx install python-lsp-server
  echo "Python-lsp-server install success"
fi

if ! pip show python-lsp-black &> /dev/null; then
  echo "Python-lsp-black install start"
  pipx install python-lsp-black --include-deps
  echo "Python-lsp-black install success"
fi

if ! pip show pylint &> /dev/null; then
  echo "Pylint install start"
  pipx install pylint
  echo "Pylint install success"
fi

echo 'PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc

echo "Vim-plug install start"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "Vim-plug install success"

NVIM_CONFIG_DIRECTORY=$HOME/.config/nvim
FONT_DIRECTORY=$HOME/.local/share/fonts
NERD_FONT="0xProtoNerdFontMono-Regular.ttf"

if [ ! -d $FONT_DIRECTORY ]; then
  echo "Create font directory start"
  mkdir $FONT_DIRECTORY 
  echo "Create font directory success"
fi

if [ ! -f "$FONT_DIRECTORY/$NERD_FONT" ]; then
  echo "Nerd font install start"
  curl -O --output-dir "$FONT_DIRECTORY" -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip
  unzip -j $FONT_DIRECTORY/0xProto.zip 0xProtoNerdFontMono-Regular.ttf -d $FONT_DIRECTORY
  rm $FONT_DIRECTORY/0xProto.zip
  echo "Nerd font install success"
fi

if [ ! -d $NVIM_CONFIG_DIRECTORY ]; then
  echo "Create nvim directory start"
  mkdir $HOME/.config/nvim
  echo "Create nvim directory success"
fi

if [ ! "$(ls $NVIM_CONFIG_DIRECTORY)" ]; then
  echo "Copying nvim config start" 
  rm -rf $HOME/.config/nvim
  cp -r ./nvim $HOME/.config/
  echo "Copying nvim config success" 
else
  echo "Failed to copy neovim config. $NVIM_CONFIG_DIRECTORY is not empty."
  echo "Follow these steps:
   1. Backup your neovim config first.
   2. Delete your neovim config with command, rm -rf $NVIM_CONFIG_DIRECTORY/*
   3. Run this script again.
  "
fi

