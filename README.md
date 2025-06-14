# get latest nvim release
* pacman
```
sudo pacman -S neovim
```
* apt
```
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

# clone nvim
```
cd ~/.config
git clone https://github.com/elijahlovold/nvim.lua.git
mv nvim.lua nvim
```

# need this for pyright: 
* pacman
```
sudo pacman -S nodejs npm
```

* apt
```
sudo snap install curl
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
sudo apt-get install -y nodejs
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
