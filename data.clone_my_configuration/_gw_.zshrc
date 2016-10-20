# Path to your oh-my-zsh installation.
export ZSH=/home/wuyulong/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH="/etc/kindex:/usr/lib64/qt-3.3/bin:/usr/local/python-2.7/bin:.:/usr/local/jdk1.7/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/wuyulong/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
# Yulong's aliases
alias hfs="hadoop fs"
alias ls="ls -B --color=tty"
alias ll="ls -ltrh"
alias rm="rm -i"
alias vi="vim"
alias sshgw="ssh gw"
# alias git-small-cur-push="pwd_out=$(pwd); cd $(git rev-parse --show-toplevel); git add -A; git commit -m 'auto whole repository changes.'; git push; cd ${pwd_out}; unset pwd_out"
alias git-small-push="git add -A; git commit -m 'small changes.'; git push"
# Call format: git-push "test push"
function git-push()
{
    message=$1
    cd $(git rev-parse --show-toplevel)
    git add -A
    git commit -m "$message"
    git push
    cd -
}
# Call format: git-push-cur "test push"
function git-push-cur()
{
    message=$1
    git add -A
    git commit -m "$message"
    git push
}
# get tail of history which match the grep pattern
function hisgrep()
{
    grep_pattern=$1
    history | grep -E --color $grep_pattern                                                
}
function hisgrept()
{                                                                               
    if [ "$#" -eq 1 ]; then
        hisgrep $1 | tail | grep --color $1
    elif [ "$#" -eq 2 ]; then
        hisgrep $1 | tail -$2 | grep --color $1
    fi
}
# add log to shell command for track conveniently
function golog()
{
    cmd=$1
    echo $cmd\n >> _cmd_log.log
    date
    zsh -c $cmd
}
alias 'git-init'='git init; cp .git/info/exclude .gitignore'
alias 'goutils'="cd ~/gitsvnlib/YulongUtils/"
alias 'hfsls'="hadoop fs -ls -h"
alias 'hfsdu'="hadoop fs -du -h"
alias 'awktab'="awk -F '\t'"
alias 'distinct'="sort | uniq "
alias 'p_kw'='gitsvnlib/DocKeywordClickFetcher/'
alias 'wcl'='wc -l'
