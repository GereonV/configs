set -o vi
export PS1='[\u@\h \W]\$ '

alias ls="ls --color=auto"
alias ll="ls -al"
alias lt="ls -alrt"
alias ingo="rm -rf"
alias rl=". $HOME/.bashrc"

mkcd() {
	mkdir -p $1 && cd $1
}
