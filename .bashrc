set -o vi
export PS1='[\u@\h \W]\$ '
type powerline-shell &> /dev/null && PROMPT_COMMAND='PS1=$(powerline-shell $?)'

alias ls="ls --color=auto"
alias ll="ls -al"
alias lt="ls -alrt"
alias ingo="rm -rf"
alias rl=". $HOME/.bashrc"
alias lg="lazygit"
alias nv="nvim"

mkcd() {
	mkdir -p $1 && cd $1
}
