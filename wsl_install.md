# Instalar ambiente de desenvolvimento no WSL

## Passo 1: configurar WSL seguindo o [guia da Microsoft](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)

## Passo 2: Instalar fonte [Meslo GSNF](https://github.com/fontmgr/MesloLGSNF/tree/main/fonts) e configurar como fonte padrão do perfil Linux no terminal

## Passo 3: configurar ubuntu rodando alguns comandos:

```bash
sudo apt update -y && sudo apt full-upgrade -y

sudo apt install vim curl git ripgrep bat  -y

# Installing exa, a substitute for ls
wget -c http://old-releases.ubuntu.com/ubuntu/pool/universe/r/rust-exa/exa_0.9.0-4_amd64.deb
sudo apt-get install ./exa_0.9.0-4_amd64.deb
rm ./exa_0.9.0-4_amd64.deb

# Downloading a nice vim configuration (check ~/.vimrc to see what's beed added)
wget https://gist.github.com/chrisyeh96/5d4479dee77e4b04786e9bc71f43967c/raw/27af7ff4456f39f6c79c6c8e6f5ded7932eddd28/.vimrc -O ~/.vimrc

# Downloading and installing tldr++, a nice CLI manual for the most used commands (run `$ tldr tldr` for a usage tutorial)
wget -O ./tldr.tgz https://github.com/isacikgoz/tldr/releases/download/v1.0.0-alpha/tldr_1.0.0-alpha_linux_amd64.tar.gz
tar -xzvf ./tldr.tgz && sudo mv tldr /usr/local/bin && sudo chmod +x /usr/local/bin/tldr && rm ./tldr.tgz

# Installing Zsh and defining it as default shell
sudo apt install zsh -y
chsh -s $(which zsh)

# Installing oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Installing Powerlevel10k. Execute p10k configure after reset the terminal to finish configuration
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

# Installing zinit (Zshell plugin manager)
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Adding oh-my-zsh plugins into ~/.zshrc
echo -e "zinit light zdharma-continuum/fast-syntax-highlighting\nzinit light zsh-users/zsh-autosuggestions\nzinit light zsh-users/zsh-completions" >> ~/.zshrc

# Setting vim as default editor
echo "export EDITOR=vim" >> ~/.zshrc

# Creating ~/bin directory
[ ! -d ~/bin ] && mkdir ~/bin

# Adding this repository
[ ! -d ~/code ] && mkdir ~/code
cd ~/code && git clone git@github.com:Dahan-Schuster/linux-utils.git 
echo "source ~/code/commands.sh" >> ~/.zshrc

# Apply changes by sourcing the zshrc file
source ~/.zshrc
```
