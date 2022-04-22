#!/bin/bash

# script for installing apps into a newly installed ubuntu 

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root, use 'sudo "$0"' instead" 1>&2
   exit 1
fi

# saves the script directory to search for other scripts later
SCRIPT=$(readlink -f "$0")
WORK_DIR=$(dirname "$SCRIPT")

FONTS="/home/$(whoami)/.local/share/fonts"

[ ! -d "$FONTS" ] && mkdir "$FONTS"

echo "Updating packages"
sudo apt update
echo

echo "Upgrading packages"
sudo apt full-upgrade
echo

UTILS="vim gedit curl git vlc pavucontrol alacarte gnome-teak-tool net-tools"
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

echo "Installing and configuring docker"
sudo apt install docker docker-compose -y
sudo usermod -aG docker $USER
echo "Docker installed. Reboot your system to apply changes"
echo

echo "Installing Google Chrome"

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt update
sudo apt install google-chrome-stable -y
echo

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

# echo "Installing Spotify"
# sudo snap install spotify  -y
# echo

if test -f "$WORK_DIR/set_shortcut.py"; then
    echo "Setting custom keyboard shortcuts"
    echo "[Tip] You can see the new shortcuts in System Settings > Keyboard Shurtcts (end of page)"

    python3 set_shortcut.py 'Open Gedit' 'gedit' '<Super>G'
    python3 set_shortcut.py 'Open Files' 'nautilus' '<Super>E'
    python3 set_shortcut.py 'Open Calculator' 'gnome-calculator' '<Control><Alt>y'
    python3 set_shortcut.py 'Open Chrome' 'google-chrome' '<Control><Alt>u'

    echo
fi

echo "Installing Zsh and defining it as default shell"
sudo apt install zsh -y
chsh -s $(which zsh)
echo

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo

echo "Installing zinit (Zshell plugin manager)"
sh -c "$(curl -fsSL https://git.io/zinit-install)"
echo

echo "Adding oh-my-zsh plugins into ~/.zshrc"
echo "zinit light zdharma-continuum/fast-syntax-highlighting" >> ~/.zshrc
echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc
echo "zinit light zsh-users/zsh-completions" >> ~/.zshrc
echo

echo "Searching for util commands in $WORK_DIR/commands.sh"
if test -f "$WORK_DIR/commands.sh"; then
    cat "$WORK_DIR/commands.sh" >> ~/.zshrc
    echo "Util commands pasted successfully into ~/.zshrc"
    echo "[Tip] Execute set_git_aliases command after shell reboot for setting some cool git aliases ;)"
else
    echo "file commands.sh not found in the same current script directory. Ignoring."
fi
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

echo "Powerlevel10k installed. Execute `p10k configure` now for finish configuration? It will run an iteractive script."
read -p "[Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    p10k configure
fi
echo

echo "End of script. Reboot is necessary in order to fully finish the configuration."
echo "Reboot now? Remember closing all the running apps to avoid loss of data."
read -p "[Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
    echo "Bye!"
fi
