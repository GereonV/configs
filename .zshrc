# vim:foldmethod=marker
# general {{{
set -o vi
setopt HIST_IGNORE_SPACE
alias top="top -o cpu"
alias ll="ls -al"
alias lt="ls -alt"
alias ingo="rm -rf"
alias rl=". ${HOME}/.zshrc"
alias st="ssh ${TROOM}"
alias lg="lazygit"
alias nv="nvim"
mkcd() { [[ $# -eq 1 ]] && mkdir -p "$1" && cd "$1" }
# }}}
# prompt {{{
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
		[[ ${BUFFER} ]] && { zle accept-line; return; }
		echo
		eza --all --icons --color
		zle reset-prompt
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
	if [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]
	then
		. /opt/homebrew/opt/fzf/shell/key-bindings.zsh
		. /opt/homebrew/opt/fzf/shell/completion.zsh
	fi
	export FZF_DEFAULT_COMMAND="fd --unrestricted --follow --exclude .git --exclude node_modules --exclude '*.pyc' . ~ ."
	export FZF_CTRL_T_COMMAND="fd --unrestricted --follow --strip-cwd-prefix --exclude .git --exclude node_modules --exclude '*.pyc'"
	export FZF_ALT_C_COMMAND="fd --type d --unrestricted --follow --exclude .git --exclude node_modules --exclude '*.pyc' . ~ ."
	if type bat eza &> /dev/null
	then
		export FZF_DEFAULT_OPTS="--preview 'bat --color always {} 2> /dev/null || eza --all --tree --icons --color always --group-directories-first {}'"
	fi
	export FZF_CTRL_R_OPTS="--preview ''"
fi
# }}}
# homebrew {{{
if type brew &> /dev/null
then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
	autoload -Uz compinit
	compinit
fi
# }}}
[[ $(uname) == "Darwin" ]] && ssh-add --apple-load-keychain 2> /dev/null
