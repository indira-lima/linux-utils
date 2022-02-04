#!/bin/bash

# script for installing apps into a newly installed ubuntu 

FONTS=~/.local/share/fonts

echo "Updating packages"
sudo apt update
echo

echo "Upgrading packages"
sudo apt full-upgrade
echo

echo "Installing system utils (vim, gedit, curl, git, vlc and pavucontrol)"
sudo apt install vim gedit curl git vlc pavucontrol -y
echo

echo "Downloading a nice vim configuration (check ~/.vimrc to see what's beed added)"
wget https://gist.github.com/chrisyeh96/5d4479dee77e4b04786e9bc71f43967c/raw/27af7ff4456f39f6c79c6c8e6f5ded7932eddd28/.vimrc -O ~/.vimrc

echo "Setting vim as default editor"
export EDITOR=vim
echo

echo "Installing and configuring docker"
sudo apt install docker docker-compose -y
sudo usermod -aG docker $USER
echo "Docker installed. Reboot your system to apply changes"
echo

echo "Downloading Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt update
echo

echo "Installing Google Chrome"
sudo apt install google-chrome-stable -y && rm /etc/apt/sources.list.d/google-chrome.list
echo

echo "Downloading VSCode"
wget https://code.visualstudio.com/sha/download\?build\=stable\&os\=linux-deb-x64 -O /tmp/vscode.deb

echo "Installing VSCode"
sudo apt install /tmp/vscode.deb -y && rm /tmp/vscode.deb

echo "Installing Fira-Code font for VSCode"
rm "$FONTS/FiraCode*"
wget https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -O /tmp/firacode.zip
unzip /tmp/firacode.zip -d /tmp/firacode
mv /tmp/firacode/ttf/* "$FONTS/"
rm -R /tmp/firacode
rm /tmp/firacode.zip
echo

echo "Installing Spotify"
sudo snap install spotify
echo

if test -f "$(pwd)/set_shortcut.py"; then
    echo "Setting custom keyboard shortcuts"
    echo "[Tip] You can see the new shortcuts in System Settings > Keyboard Shurtcts (end of page)"

    python3 set_shortcut.py 'Open Gedit' 'gedit' '<Super>G'
    python3 set_shortcut.py 'Open Files' 'nautilus' '<Super>E'
    python3 set_shortcut.py 'Open Calculator' 'gnome-calculator' '<Control><Alt>y'
    python3 set_shortcut.py 'Open Chrome' 'google-chrome' '<Control><Alt>u'

    echo
fi

echo "Installing Zsh and defining as default shell"
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

echo "Searching for util commands in $(pwd)/commands.sh"
if test -f "$(pwd)/commands.sh"; then
    cat "$(pwd)/commands.sh" >> ~/.zshrc
    echo "Util commands pasted successfully into ~/.zshrc"
    echo "[Tip] Execute set_git_aliases command after shell reboot for setting some cool git aliases ;)"
else
    echo "file commands.sh not found in current dir. Ignoring."
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

echo "Powerlevel10k installed. Execute `p10k configure` now for finish configuration?"
read -p "[Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    p10k configure
fi
echo

echo "End of script. Reboot is necessary in order to fully finish the configuration."
echo "Reboot now? Remember closing all the running apps to avoid loss"
read -p "[Y/n] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
fi
