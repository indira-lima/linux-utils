# Instalar ambiente de desenvolvimento no WSL

1. Configurar WSL seguindo o [guia da Microsoft](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)

2. Instalar fonte [Meslo GSNF](https://github.com/fontmgr/MesloLGSNF/tree/main/fonts) e configurar como fonte padrão do perfil Linux no terminal

3. Adicionar chave nova chave ssh à conta do github:

    ```bash
    ssh-keygen
    cat ~/.ssh/<key_name>.pub
    # Copiar a chave e adicionar no github
    ```

4. configurar ubuntu rodando alguns comandos:

    ```bash
    sudo apt update -y && sudo apt full-upgrade -y
    
    sudo apt install vim curl git ripgrep bat python3-pip -y
    
    # Installing exa, a substitute for ls
    wget -c http://old-releases.ubuntu.com/ubuntu/pool/universe/r/rust-exa/exa_0.9.0-4_amd64.deb
    sudo apt-get install ./exa_0.9.0-4_amd64.deb
    rm ./exa_0.9.0-4_amd64.deb
    
    # Downloading a nice vim configuration (check ~/.vimrc to see what's beed added)
    wget https://gist.github.com/chrisyeh96/5d4479dee77e4b04786e9bc71f43967c/raw/27af7ff4456f39f6c79c6c8e6f5ded7932eddd28/.vimrc -O ~/.vimrc
    
    # Downloading and installing tldr++, a nice CLI manual for the most used commands (run `$ tldr tldr` for a usage tutorial)
    wget -O ./tldr.tgz https://github.com/isacikgoz/tldr/releases/download/v1.0.0-alpha/tldr_1.0.0-alpha_linux_amd64.tar.gz
    tar -xzvf ./tldr.tgz && sudo mv tldr /usr/local/bin && sudo chmod +x /usr/local/bin/tldr && rm ./tldr.tgz
    
    # Installing nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    
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
    echo "source ~/code/linux-utils/commands.sh" >> ~/.zshrc
    
    # Apply changes by sourcing the zshrc file
    source ~/.zshrc
    ```

5. Configurar nvim com arquivo de configurações: [dotvim](https://github.com/Dahan-Schuster/dotvim)

    ```bash
    cd ~/code && git clone git@github.com:Dahan-Schuster/dotvim.git
    [ ! -d ~/.config ] && mkdir ~/.config
    ln -sf ~/code/dotvim ~/.config/nvim
    
    # Instalar nvim
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && sudo rm -rf /opt/nvim && sudo tar -C /opt -xzf nvim-linux64.tar.gz
    echo "export PATH=\"$PATH:/opt/nvim-linux64/bin\"" >> ~/.zshrc && source ~/.zshrc
    
    # instalar node 18
    nvm install 18
    npm install -g yarn
    
    # abrir o nvim para instalar os pacotes
    nvim
    
    # fechar e navegar até a pasta do coc.nvim para instalar as dependências
    cd ~/code/dotvim/pack/minpac/opt/coc.nvim && yarn
    
    # abrir nvim de novo para deixar o coc instalar as extensões
    cd ~/code/dotvim && nvim
    
    # Instalar pynvim
    pip3 install --upgrade pynvim
    
    # Instalar neovim no npm
    npm install -g neovim
    ```

6. Adicionar configuração de clipboard no nvim usando win32yark

  - Baixar win32yank.exe no Windows, adicionar a uma pasta de preferência onde haja apenas executáveis (ex.: C:/Windows/Tools), e adicionar ao path do wsl

    ```bash
    echo "export PATH=\"$PATH:/mnt/c/<PATH_TO_WIN32YANK_FOLDER>\"" >> ~/.zshrc && source ~/.zshrc
    ```
    
  - Adicionar a configuração de clipboard no init.vim ou outro arquivo carregado na inicialização do nvim:
    
    ```vim
    let g:clipboard = {
      \   'name': 'win32yank-wsl',
      \   'copy': {
      \      '+': 'win32yank.exe -i --crlf',
      \      '*': 'win32yank.exe -i --crlf',
      \    },
      \   'paste': {
      \      '+': 'win32yank.exe -o --lf',
      \      '*': 'win32yank.exe -o --lf',
      \   },
      \   'cache_enabled': 0,
      \ }
    ```
