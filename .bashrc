set -o vi
export PS1='[\u@\h \W]\$ '
type powerline-shell &> /dev/null && PROMPT_COMMAND='PS1=$(powerline-shell $?)'

export VISUAL
if type nvim &> /dev/null; then
	VISUAL=nvim
elif type vim &> /dev/null; then
	VISUAL=vim
elif [[ ! -v VISUAL ]]; then
	unset VISUAL
fi

alias ls="ls --color=auto"
alias ll="ls -al"
alias lt="ls -alrt"
alias ingo="rm -rf"
alias rl=". ${HOME}/.bashrc"
alias lg="lazygit"
alias nv="nvim"

mkcd() {
	mkdir -p $1 && cd $1
}
