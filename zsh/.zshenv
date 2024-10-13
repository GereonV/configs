export PATH
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -f "${HOME}/.cargo/env" ]] && . "${HOME}/.cargo/env" && {
	mkdir -p "${HOME}/.zfunc"
	[[ -a "${HOME}/.zfunc/_rustup" ]] || rustup completions zsh > "${HOME}/.zfunc/_rustup"
	[[ -a "${HOME}/.zfunc/_cargo" ]] || rustup completions zsh cargo > "${HOME}/.zfunc/_cargo"
	[[ -a "${HOME}/.zfunc/_rustc" ]] || curl https://raw.githubusercontent.com/rust-lang/zsh-config/refs/heads/master/_rust > "${HOME}/.zfunc/_rustc"
}
PATH="${HOME}/.local/bin:${PATH}"
FPATH="${FPATH}:${HOME}/.zfunc"
[[ -z "${BASH_ENV}" && -f "${HOME}/.bashenv" ]] && export BASH_ENV="${HOME}/.bashenv"
