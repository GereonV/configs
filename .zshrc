ret_prompt_string() {
	[[ $? == 0 ]] && echo "%B%F{cyan}☑%f%b" || echo "%B%F{red}☒%f%b"
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

set -o vi
ssh-add --apple-load-keychain 2> /dev/null
export TROOM="dv642098@troom1gw.zam.kfa-juelich.de"
export PROMPT='$(ret_prompt_string) %F{green}%n%f@%F{magenta}%m%f:%F{magenta}%~%F{yellow}$(git_prompt_string)%f $ '
type powerline-shell &> /dev/null && PROMPT='$(powerline-shell --shell zsh $?)'
setopt PROMPT_SUBST

fg-bg() {
	[[ ${#BUFFER} == 0 ]] || return 0
	BUFFER=fg
	zle accept-line
}
zle -N fg-bg # register widget (defaults to executing function with same name)
bindkey '^z' fg-bg # bind widget

alias top="top -o cpu"
alias ll="ls -al"
alias lt="ls -alrt"
alias ingo="rm -rf"
alias python="python3"
alias rl=". $HOME/.zshrc"
alias st="ssh ${TROOM}"
alias lg="lazygit"
alias nv="nvim"

mkcd() {
	mkdir -p $1 && cd $1
}

if type brew &> /dev/null
then
  	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	autoload -Uz compinit
	compinit
fi
if [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]
then
	. /opt/homebrew/opt/fzf/shell/key-bindings.zsh
	. /opt/homebrew/opt/fzf/shell/completion.zsh
fi
export FZF_DEFAULT_COMMAND="fd --unrestricted --follow --exclude .git --exclude node_modules --exclude '*.pyc' . ~ ."
export FZF_CTRL_T_COMMAND="fd --unrestricted --follow --strip-cwd-prefix --exclude .git --exclude node_modules --exclude '*.pyc'"
export FZF_ALT_C_COMMAND="fd --type d --unrestricted --follow --exclude .git --exclude node_modules --exclude '*.pyc' . ~ ."
export FZF_DEFAULT_OPTS="--preview 'bat --color always {} 2> /dev/null || eza --all --tree --icons --color always --group-directories-first {}'"
