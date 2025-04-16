#!/bin/bash

if ! command -v git &> /dev/null; then
  echo "Git install start"
  sudo apt-get -y install git
  echo "Git install end"
fi

if ! command -v nvim &> /dev/null; then
  echo "Neovim install start"
  sudo apt-get -y install neovim
  echo "Neovim install success"
fi

if ! command -v curl &> /dev/null; then
  echo "Curl install start"
  sudo apt-get -y install curl
  echo "Curl install success"
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

