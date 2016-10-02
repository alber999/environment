function read_dom {
	local IFS=\>
	read -d \< ENTITY CONTENT
}
function pom_info {
	if [ -f pom.xml ]
        then
	  while read_dom
	  do
	    if [ "$ENTITY" == "version" ]
	    then
		echo ": $CONTENT"
		break
	    fi
	  done < pom.xml
        fi
}
function parse_git_dirty {
  [ -r .git ] &&  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
}
function cd {
    builtin cd "$1"
    source ~/.bashrc
}

PS1="${debian_chroot:+($debian_chroot)}\[\033[36m\]\u\[\033[00m\]:\[\033[33m\]\W\[\033[00m\] \[\033[31m\]$(parse_git_branch)\[\033[m\]\[\033[39m\]$(parse_git_dirty)\[\033[m\]\[\033[91m\]$(pom_info)\[\033[m\]\$ "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias d='ls -l'
alias da='ls -la'
alias gl='git l -n10'
alias gb='git branch'
alias gf='git fetch'
alias gs='git status'
alias cd='cd "$@"'
alias b='source ~/.bashrc'

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

test -r /sw/bin/init.sh && . /sw/bin/init.sh