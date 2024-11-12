# get latest nvim release
```
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

# install packer
```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
 
# clone nvim
```
cd ~/.config
git clone https://github.com/elijahlovold/nvim.lua.git
mv nvim.lua nvim
```

# :PackerSync in nvim to download

# need this for pyright: 
```
sudo snap install curl
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
sudo apt-get install -y nodejs
```

# may need this at some point
```
sudo apt install npm
```

# :Mason -> download lsps

# install Fira Code Nerd Font from: 
```
$ wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
$ unzip FiraCode.zip -d firaCode
$ sudo cp firaCode /usr/share/fonts/
$ fc-cache -f -v
```
