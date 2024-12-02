# general {{{
set -o vi
setopt auto_cd # change to directory without `cd`
setopt extended_glob # enable patterns with `^` and `#` and unambiguous glob-qualifiers
setopt magic_equal_subst # do filename substitution on `stuff --dir=~/output`
autoload zmv # mass renaming eg. `zmv 'file(<1-5>).(*)' '$1/file.$2'`
alias zcp='zmv -C' zln='zmv -L' # likewise, but for copying/linking
alias top="top -o cpu"
if type eza &> /dev/null
then
	export EZA_ICONS_AUTO= # like an implicit --icons=auto
	alias ls="eza --classify --hyperlink"
	alias ll="eza --classify --hyperlink --all --long --header --total-size --mounts --git --git-repos"
	alias lt="eza --classify --hyperlink --all --long --header --total-size --mounts --git --git-repos --sort=modified --reverse"
else
	alias ls="ls --color=auto --hyperlink=auto"
	alias ll="ls --almost-all --si -l"
	alias lt="ls --almost-all --si -l --time=modification"
fi
alias ingo="rm -rf"
alias rl=". ${HOME}/.zshrc"
alias g="git"
alias lg="lazygit"
alias nv="nvim"
mkcd() { [[ $# -eq 1 ]] && mkdir -p "$1" && cd "$1" }
add-venv-path() {
	local dir
	for dir in .venv venv
	do
		[[ -d "${dir}" ]] || continue
		. ${dir}/bin/activate || return
		dir=("${dir}"/lib/python3.*/site-packages) && [[ $#dir -eq 1 ]] || return
		export PYTHONPATH="${dir}${PYTHONPATH+:${PYTHONPATH}}"
		return
	done
	echo "no venv found" >&2
	return 1
}
export VISUAL=nvim
# }}}
# history {{{
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS # alternative: HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# }}}
# zle widgets {{{
# fg using <C-z> {{{
fg-bg() {
	local no_ws=${BUFFER// /}
	[[ ${#no_ws} -eq 0 ]] || return 0
	echo
	fg
}

zle -N fg-bg # register widget (defaults to executing function with same name)
bindkey '^z' fg-bg # bind widget
# }}}
# eza/ls when changing dir or pressing enter {{{
ls_on_enter() {
	[[ ${BUFFER} ]] || BUFFER=" ls --all"
	zle accept-line
}
zle -N ls_on_enter
bindkey '^m' ls_on_enter

# must be a function
ls_on_cd() { ls; }
chpwd_functions=(ls_on_cd)
# }}}
# }}}
# fzf {{{
if type fzf fd &> /dev/null
then
	export FZF_DEFAULT_COMMAND="fd --unrestricted --follow --exclude .git --exclude node_modules --exclude '*.pyc' . ~ ."
	export FZF_CTRL_T_COMMAND="fd --unrestricted --follow --strip-cwd-prefix --exclude .git --exclude node_modules --exclude '*.pyc'"
	export FZF_ALT_C_COMMAND="fd --type d --unrestricted --follow --exclude .git --exclude node_modules --exclude '*.pyc' . ~ ."
	if type bat eza > /dev/null
	then
		export FZF_CTRL_T_OPTS="--preview 'bat --color always {} 2> /dev/null || eza --color=always --icons=always --classify --hyperlink --all --mounts --tree --level=1 --group-directories-first {}'"
		export FZF_COMPLETION_OPTS=
	fi
	_fzf_compgen_path() {
		fd --unrestricted --follow --exclude ".git" --exclude "node_modules" --exclude '*.pyc' . "$1"
	}
	_fzf_compgen_dir() {
		fd --type d --unrestricted --follow --exclude ".git" --exclude "node_modules" --exclude '*.pyc' . "$1"
	}
	_fzf_comprun() {
		local command=$1
		shift
		case "${command}" in
			cd) type eza > /dev/null && fzf --preview "eza --color=always --icons=always --all --mounts -1 --group-directories-first" "$@" || fzf "$@";;
			export|unset|unalias)       fzf "$@";;
			ssh|telnet)                 fzf --preview "dig {}" "$@";;
			*)                          fzf "$@";;
		esac
	}
	eval "$(fzf --zsh)"
fi
# }}}
# prompt (not in use) {{{
setopt PROMPT_SUBST
# custom prompt {{{
ret_prompt_string() {
	[[ $? -eq 0 ]] && echo "%B%F{cyan}☑%f%b" || echo "%B%F{red}☒%f%b"
}

git_prompt_string() {
	local branch git_status bits
	branch=$(git branch --show-current 2> /dev/null) || return 0
	git_status=$(git status)
	bits=
	echo "${git_status}" | grep -q "modified:" && bits+=!
	echo "${git_status}" | grep -q "deleted:" && bits+=x
	echo "${git_status}" | grep -q "Untracked files:" && bits+=?
	echo "${git_status}" | grep -q "new file:" && bits+=+
	echo "${git_status}" | grep -q "Your branch is ahead of" && bits+=*
	echo "${git_status}" | grep -q "renamed:" && bits+=">"
	[[ ${bits} ]] && echo " (${bits} ${branch})" || echo " (${branch})"
}

export PROMPT='$(ret_prompt_string) %F{green}%n%f@%F{magenta}%m%f:%F{magenta}%~%F{yellow}$(git_prompt_string)%f $ '
# }}}
# powerline-shell {{{
type powerline-shell &> /dev/null && PROMPT='$(powerline-shell --shell zsh $?)'
# }}}
# }}}
# homebrew {{{
if type brew &> /dev/null
then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
# }}}
# zinit {{{
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d ${ZINIT_HOME} ]]
then
	mkdir -p "$(dirname ${ZINIT_HOME})"
	git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi && . "${ZINIT_HOME}/zinit.zsh" || rm -rf "${ZINIT_HOME}"
if type zinit > /dev/null
then
	zinit ice depth=1 # parameter to git clone
	zinit light romkatv/powerlevel10k # p10k prompt
	if type fzf > /dev/null
	then
		zinit light Aloxaf/fzf-tab
		zstyle ':completion:*' menu no # no idea what this does
		zstyle ':completion:*:git-checkout:*' sort false
		zstyle ':completion:*:descriptions' format '[%d]' # enables groups
		zstyle ':fzf-tab:*' switch-group '<' '>' # default is F1 and F2
		zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always --all -1 --mounts --group-directories-first ${realpath}'
	fi
	zinit light zsh-users/zsh-completions # additional, non-standard completions
	zinit light zsh-users/zsh-autosuggestions # complete whole command
	bindkey '^f' autosuggest-accept
	zinit snippet OMZP::sudo # double escapes fixes missing sudo
	# zinit snippet OMZP::git-auto-fetch # careful with 'git push --force-with-lease'
	zinit snippet OMZP::colored-man-pages
	zinit light zsh-users/zsh-syntax-highlighting
fi
# }}}
# completions {{{
# custom {{{
FPATH="${FPATH}:${HOME}/.zfunc"
# Rust {{{
type cargo &> /dev/null && {
	mkdir -p "${HOME}/.zfunc"
	[[ -a "${HOME}/.zfunc/_rustup" ]] || (rustup completions zsh > "${HOME}/.zfunc/_rustup" &)
	[[ -a "${HOME}/.zfunc/_cargo" ]] || (rustup completions zsh cargo > "${HOME}/.zfunc/_cargo" &)
	[[ -a "${HOME}/.zfunc/_rustc" ]] || (curl --no-progress-meter https://raw.githubusercontent.com/rust-lang/zsh-config/refs/heads/master/_rust > "${HOME}/.zfunc/_rustc" &)
}
# }}}
# }}}
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # color completions
autoload -Uz compinit && compinit
type zinit > /dev/null && zinit cdreplay -q
# }}}
# vim: foldmethod=marker

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
