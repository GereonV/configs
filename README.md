# Configuration files (aka. dotfiles)

## Installation

Install `git` and `stow`:
```sh
sudo pacman -S git stow
```

Clone this repository:
```sh
git clone https://github.com/GereonV/configs.git
cd configs
```

Choose which *packages* to create symlinks for:
```sh
stow git ssh bash
```

Make sure to also install the necessary dependencies:
```sh
sudo pacman -S git openssh bash
```

## Packages

| package         | dependencies                                                     | notes                             |
|-----------------|------------------------------------------------------------------|-----------------------------------|
| alacritty       | alacritty, zsh, ttf-jetbrains-mono-nerd                          |                                   |
| bash            | bash                                                             | re-login required for full effect |
| discord         | discord                                                          |                                   |
| dmenu           | dmenu (pass, pass-otp)                                           | passwords require `pass`-setup    |
| git             | git (openssh)                                                    |                                   |
| gtk             |                                                                  | global dark-theme                 |
| i3              | i3-wm, i3blocks, dmenu, *a terminal* (playerctl, pipewire-pulse) |                                   |
| nvim            | neovim (*language servers*)                                      |                                   |
| powerline-shell | [powerline-shell](https://github.com/b-ryan/powerline-shell)     |                                   |
| ranger          | ranger                                                           |                                   |
| ssh             | openssh                                                          |                                   |
| vim             | vim                                                              |                                   |
| zsh             | zsh                                                              | re-login required for full effect |
