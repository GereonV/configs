export PATH
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f "${HOME}/.cargo/env" ]] && . ${HOME}/.cargo/env
PATH="${HOME}/.local/bin:${PATH}"
[[ -z "${BASH_ENV}" && -f "${HOME}/.bashenv" ]] && export BASH_ENV="${HOME}/.bashenv"
