# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

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
plugins=(
    git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias add_ssh_key='eval `ssh-agent` > /dev/null && ssh-add'

print_aws_instances() {
    aws ec2 describe-instances --filters --filters "Name=tag:project,Values=$1" "Name=instance-state-name,Values=running" | egrep "PublicIpAddress|InstanceType|ImageId|\"$1\""
}

export GLOBIGNORE='*~'

git_diff_terminal() {
    git diff --ignore-submodules --color $* | cat
}

git_branch_archive() {
    git branch -m $1 OLD_$1
}

ssh_ec2() {
    ssh ubuntu@${1} -i ~/.ssh/id_rsa_admin
}

alias gs='git status'
alias gl='git log --decorate'
alias gd='git diff --src-prefix="SRC " --dst-prefix="DST "'

export PATH="/usr/local/opt/python@2/bin:$PATH"

# disable git autocompletion
compdef -d git

##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
#setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# bind up/down arrows to local history only
bindkey "OA" up-line-or-local-history
bindkey "OB" down-line-or-local-history

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

# try to allow auto completion inside of tokens
#zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH=~/.local/bin:~/bin/:$PATH
alias k=kubectl

# kubectl autocomplete?
autoload -Uz compinit
compinit

alias dutop='find . -type f | xargs du -sm | awk "\$1 > 5"'


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/greg/bin/s5cmd s5cmd


function ric() {
    run_in_container.py \'$1\'
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

zstyle ':completion:*' menu select
fpath+=~/.zfunc

plugins=(git autojump colored-man-pages bazel)

source ~/.bazel-cmds

alias kget='kubectl get --sort-by=.status.startTime'

export WANDB_API_KEY="e7f6da7976d69f9179d13b94698c303708804afe"

alias aw=/data/bin/aw_cli/latest

# more cmd history
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE


export TZ="America/Los_Angeles"

alias lego_jobs="kubectl get pods -n lego-fsx-production -o=custom-columns='_PROJECT:.metadata.labels.project,_TASK:.metadata.labels.task,_DESC:.metadata.labels.description' | sort | uniq -c"

function dus () {
    du -s --block-size=1G --threshold=1G "$@" | sort -nk1
}
export dus

function dus_all () {
    find $1 -type d | xargs zsh --login -c 'dus "$@"'
}


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/greg/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/greg/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/greg/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/greg/google-cloud-sdk/completion.zsh.inc'; fi
