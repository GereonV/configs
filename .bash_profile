export PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
. "${HOME}/.cargo/env"
PATH="${HOME}/.local/bin:${PATH}"
[[ -z "${BASH_ENV}" && -f ~/.bashenv ]] && export BASH_ENV=~/.bashenv
[[ $- == *i* && -f ~/.bashrc ]] && . ~/.bashrc
