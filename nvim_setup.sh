#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
RED='\033[1;31m'
NO_COLOR='\033[0m'

is_debian_based=false
is_arch_based=false

debian_based_distros=("linux mint" "ubuntu" "debian gnu/linux")
arch_based_distros=("manjaro linux")

get_installed_distro_name(){
  distro=$(cat /etc/os-release | awk -F "=" '/^NAME/ {print $2}' | sed 's/\"//g')
  echo "${distro,,}"
}

installed_distro_name=$(get_installed_distro_name)

echo -e "${CYAN}Installing nvim for $installed_distro_name${NO_COLOR}"

if [[ "${debian_based_distros[@]}" =~ $installed_distro_name ]]; then
  is_debian_based=true 
elif [[ "${arch_based_distros[@]}" =~ $installed_distro_name ]]; then
  is_arch_based=true 
else
  echo -e "${ORANGE}Linux distro not supported${NO_COLOR}"
  exit 1
fi

format_message(){
  echo -e "${GREEN}$1${NO_COLOR}"
}

abort_if_install_fails(){
  if [[ $? > 0 ]]; then
    echo -e "${RED}Failed to install $1${NC}"
    exit 1
  fi
}

softwares=(git curl unzip ripgrep xclip)

if [ $is_debian_based = true ]; then
  softwares+=(python3-pip pipx)
fi

if [ $is_arch_based = true ]; then
  softwares+=(python-pip python-pipx)
fi

for software in ${softwares[@]}
do
  if ! command -v $software &> /dev/null; then
    format_message "$software install start"
    if [ $is_debian_based = true ]; then
      sudo apt-get -y install $software

      abort_if_install_fails $software
    fi

    if [ $is_arch_based = true ]; then
      sudo pacman -S --noconfirm $software

      abort_if_install_fails $software
    fi
    format_message "$software install success"
  fi
done

if ! command -v nvim &> /dev/null; then
  NVIM_ARCHIVE_FILE=nvim-linux-x86_64.tar.gz
  NVIM_VERSION=v0.10.4

  format_message "Neovim $NVIM_VERSION install start"
  curl -O --output-dir $HOME -L https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$NVIM_ARCHIVE_FILE
  tar -xzf $HOME/$NVIM_ARCHIVE_FILE -C $HOME
  sudo mv $HOME/nvim-linux-x86_64 /opt/nvim
  sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm $HOME/$NVIM_ARCHIVE_FILE
  format_message "Neovim $NVIM_VERSION install success"
fi

python_packages=(python-lsp-server python-lsp-black pylint)

for python_package in ${python_packages[@]}
do
  if ! pip show $python_package &> /dev/null; then
    format_message "$python_package install start"
    pipx install $python_package 

    abort_if_install_fails $python_package

    pipx ensurepath
    format_message "$python_package install success"
  fi
done

if ! command -v node -v &> /dev/null; then
  NODEJS_VERSION=20
  format_message "Nodejs v$NODEJS_VERSION install start"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

  if [ -d $HOME/.nvm ]; then
    \. "$HOME/.nvm/nvm.sh"
  else
    \. "$HOME/.config/nvm/nvm.sh"
  fi

  nvm install $NODEJS_VERSION
  format_message "Nodejs install success"
fi

nodejs_packages=(typescript typescript-language-server)

for nodejs_package in ${nodejs_packages[@]}
do
  if ! npm list -g $nodejs_package | grep "$nodejs_package" ; then
    format_message "$nodejs_package install start"
    npm install -g $nodejs_package

    abort_if_install_fails $nodejs_package
    format_message "$nodejs_package install success"
  fi
done

format_message "Vim-plug install start"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
format_message "Vim-plug install success"

NVIM_CONFIG_DIRECTORY=$HOME/.config/nvim
FONT_DIRECTORY=$HOME/.local/share/fonts
NERD_FONT="0xProtoNerdFontMono-Regular.ttf"

if [ ! -d $FONT_DIRECTORY ]; then
  format_message "Create font directory start"
  mkdir $FONT_DIRECTORY 
  format_message "Create font directory success"
fi

if [ ! -f "$FONT_DIRECTORY/$NERD_FONT" ]; then
  format_message "Nerd font install start"
  curl -O --output-dir "$FONT_DIRECTORY" -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/0xProto.zip
  unzip -j $FONT_DIRECTORY/0xProto.zip 0xProtoNerdFontMono-Regular.ttf -d $FONT_DIRECTORY
  rm $FONT_DIRECTORY/0xProto.zip
  format_message "Nerd font install success"
fi

if [ ! -d $NVIM_CONFIG_DIRECTORY ]; then
  format_message "Create nvim directory start"
  mkdir $HOME/.config/nvim
  format_message "Create nvim directory success"
fi

if [ ! "$(ls $NVIM_CONFIG_DIRECTORY)" ]; then
  format_message "Copying nvim config start" 
  rm -rf $HOME/.config/nvim
  cp -r ./nvim $HOME/.config/
  format_message "Copying nvim config success" 
else
  echo "Failed to copy neovim config. $NVIM_CONFIG_DIRECTORY is not empty."
  echo "Follow these steps:
   1. Backup your neovim config first.
   2. Delete your neovim config with command, rm -rf $NVIM_CONFIG_DIRECTORY/*
   3. Run this script again.
  "
fi

