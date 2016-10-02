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
                echo -e ": \e[01;91m$CONTENT\e[00m"
                break
            fi
          done < pom.xml
        fi
}
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo -e "\e[39m*\e[00m"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)$(pom_info)/"
}

PS1='${debian_chroot:+($debian_chroot)}\[\033[36m\]\u\[\033[00m\]:\[\033[33m\]\w\[\033[00m\] \[\033[31m\]$(parse_git_branch)\[\033[00m\]\[\033[32m\]\$\[\033[00m\] '

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias d='ls -l'
alias da='ls -la'
alias gl='git l -n10'
alias gb='git branch'
alias gf='git fetch'
alias gs='git status'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi