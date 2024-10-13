export PATH
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f ~/.cargo/env ]] && . ~/.cargo/env
PATH="${HOME}/.local/bin:${PATH}"
[[ -z "${BASH_ENV}" && -f ~/.bashenv ]] && export BASH_ENV=~/.bashenv
[[ $- == *i* && -f ~/.bashrc ]] && . ~/.bashrc
