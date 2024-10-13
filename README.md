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
