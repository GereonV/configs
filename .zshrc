if [ -e /usr/local/etc/user.zprofile ]
then
    source /usr/local/etc/user.zprofile
fi

ssh-add --apple-load-keychain 2> /dev/null

alias top="top -o cpu"
alias ll="ls -al"
alias lt="ls -alrt"
alias python="python3"
alias rl=". $HOME/.zshrc"
alias st="ssh dv642098@troom1gw.zam.kfa-juelich.de"
export TROOM="dv642098@troom1gw.zam.kfa-juelich.de"
export PATH="/usr/local/jdk/bin:${PATH}"
export C_INCLUDE_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/"
export CPLUS_INCLUDE_PATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/"
export LIBRARY_PATH="${LIBRARY_PATH}:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"

cdmk() {
	mkdir -p $1 && cd $1
}
