Note, for apt machines, do this to get latest:
```sh
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

Use a nerd font. Manual installation if package manager doesn't have it:
```sh
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip -d firaCode
sudo cp firaCode /usr/share/fonts/
fc-cache -f -v
```

Lsps are installed via package manager now.
