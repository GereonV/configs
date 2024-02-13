set -o vi
ssh-add --apple-load-keychain 2> /dev/null
export TROOM="dv642098@troom1gw.zam.kfa-juelich.de"
export PROMPT="%B%{%F{black}%}%n@%m%{%f%}%b %{%F{blue}%}%~ %{%f%}%% "

alias top="top -o cpu"
alias ll="ls -al"
alias lt="ls -alrt"
alias ingo="rm -rf"
alias python="python3"
alias rl=". $HOME/.zshrc"
alias st="ssh ${TROOM}"

mkcd() {
	mkdir -p $1 && cd $1
}
