#!/bin/bash

# script for installing apps into a newly installed ubuntu 

#if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run as root, use 'sudo "$0"' instead" 1>&2
#   exit 1
#fi

# saves the script directory to search for other scripts later
SCRIPT=$(readlink -f "$0")
WORK_DIR=$(dirname "$SCRIPT")

FONTS="/home/$(whoami)/.local/share/fonts"

[ ! -d "$FONTS" ] && mkdir "$FONTS"

echo "Updating packages"
sudo apt update -y
echo

echo "Upgrading packages"
sudo apt full-upgrade -y
echo

UTILS="vim gedit curl git vlc pavucontrol alacarte gnome-tweak-tool net-tools xbacklight playerctl keepassxc rofi scrot gpicview redshift-gtk flameshot i3 lightdm cmatrix neofetch"
echo "Installing some system utilities ($UTILS)"
echo $UTILS | xargs sudo apt install -y
echo

echo "Downloading a nice vim configuration (check ~/.vimrc to see what's beed added)"
wget https://gist.github.com/chrisyeh96/5d4479dee77e4b04786e9bc71f43967c/raw/27af7ff4456f39f6c79c6c8e6f5ded7932eddd28/.vimrc -O ~/.vimrc
echo

echo "Downloading and installing tldr++, a nice CLI manual for the most used commands (run `$ tldr tldr` for a usage tutorial)"
wget -O /tmp/tldr.tgz https://github.com/isacikgoz/tldr/releases/download/v1.0.0-alpha/tldr_1.0.0-alpha_linux_amd64.tar.gz
cd /tmp && tar -xzvf tldr.tgz
cd tldr
sudo mv tldr /usr/local/bin
sudo chmod +x /usr/local/bin/tldr
cd $WORK_DIR

echo "Setting vim as default editor"
export EDITOR=vim
echo

#echo "Installing Opera (f*ck Chrome)"


echo "Installing VSCode"
wget https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-deb-x64 -O /tmp/vscode.deb
sudo apt install /tmp/vscode.deb -y && rm /tmp/vscode.deb

echo "Installing Fira-Code font for VSCode"
rm "$FONTS/FiraCode*"
wget https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -O /tmp/firacode.zip
unzip /tmp/firacode.zip -d /tmp/firacode
mv /tmp/firacode/ttf/* "$FONTS/"
rm -R /tmp/firacode
rm /tmp/firacode.zip
echo

echo "Installing Zsh and defining it as default shell"
sudo apt install zsh -y
chsh -s $(which zsh)
echo

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo

echo "Installing Powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
echo

echo "Installing necessary fonts for Powerlevel10k"
rm "$FONTS/MesloLGS*"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O "$FONTS/MesloLGS NF Regular.ttf"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O "$FONTS/MesloLGS NF Bold.ttf"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O "$FONTS/MesloLGS NF Italic.ttf"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O "$FONTS/MesloLGS NF Bold Italic.ttf"
echo

echo "Powerlevel10k installed. Execute p10k configure after reset the terminal to finish configuration. It will run an iteractive script."
echo

echo 'Installing zinit (Zshell plugin manager)'
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo "Adding oh-my-zsh plugins into ~/.zshrc"
echo "zinit light zdharma-continuum/fast-syntax-highlighting" >> ~/.zshrc
echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc
echo "zinit light zsh-users/zsh-completions" >> ~/.zshrc
echo

echo "Creating ~/bin directory"
[ ! -d ~/bin ] && mkdir ~/bin

if [ -f "$WOR_KDIR/commands.sh" ]; then
    echo "commands.sh found in the current directory, copying it to ~/bin and sourcing in ~/.zshrc"
    cd $WORK_DIR
    cp ./commands.sh ~/bin
    echo "source $WORK_DIR/commands.sh" >> ~/.zshrc
fi

echo "Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo 'End of script. Reboot is necessary in order to fully finish the configuration.'
echo 'Reboot now? Remember closing all the running apps to avoid loss of data.'
read -p '[Y/n] ' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
    echo "Bye!"
fi	
