# vim:foldmethod=marker
# general {{{
set -o vi
alias top="top -o cpu"
alias ls="ls --color"
alias ll="ls -al"
alias lt="ls -alt"
alias ingo="rm -rf"
alias rl=". ${HOME}/.zshrc"
alias st="ssh ${TROOM}"
alias g="git"
alias lg="lazygit"
alias nv="nvim"
mkcd() { [[ $# -eq 1 ]] && mkdir -p "$1" && cd "$1" }
# }}}
# history {{{
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS # alternative: HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
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
# eza when changing dir or pressing enter {{{
if type eza &> /dev/null
then
	ls_on_enter() {
		[[ ${BUFFER} ]] || BUFFER=" eza --all --icons --color"
		zle accept-line
	}
	zle -N ls_on_enter
	bindkey '^m' ls_on_enter

	ls_on_cd() { eza --icons --color; }
	chpwd_functions=(ls_on_cd)
fi
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
		export FZF_CTRL_T_OPTS="--preview 'bat --color always {} 2> /dev/null || eza --all --tree --icons --color always --group-directories-first {}'"
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
			cd) type eza > /dev/null && fzf --preview "eza --all --tree --icons --color always --group-directories-first" "$@" || fzf "$@";;
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
	# eval "$(brew shellenv)"
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
		zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --all -1 --icons --color always --group-directories-first ${realpath}'
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
[[ $(uname) == "Darwin" ]] && ssh-add --apple-load-keychain 2> /dev/null
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # color completions
autoload -Uz compinit && compinit
type zinit > /dev/null && zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || . ~/.p10k.zsh
