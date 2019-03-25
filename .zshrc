# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/home/xttjsn/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="arrow"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
	 emacs
	 extract
	 debian
	 copyfile
	 git-flow
	 gob
	 gitignore
	 z)

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

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib64:/usr/lib64

source ~/.py35/bin/activate
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export QUANDL_API_KEY=3UJToQtp6zKjqSGZhovK
alias jn=jupyter-notebook
export INTRINIO_API_KEY=OjQ0OTk5NWNhNzhlNzYzYWY1MjYwZjA5ZDQ5YmRiNjQw
export INTRINIO_USER='7518fb6528c6ae632eaf06e4849bca74'
export INTRINIO_PWD='f2b223e23f63ea129fcf6d424e332224'

alias cs166='cd ~/Dropbox/Brown/Course/1660'
alias browncs='ssh txiaotin@ssh.cs.brown.edu'
alias sf='screenfetch -A "Mac OS X"'
alias sc='source ~/.zshrc'

export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
export GIT_TERMINAL_PROMPT=1

export PATH=$PATH:~/.local/bin

function zipline_run {
    zipline run -f ~/.py35/lib/python3.5/site-packages/zipline/examples/buyapple.py -s 2012-01-02 -e 2018-12-01
}

function zipline_recover {
    cp ~/.ziplinedata/quandl/2019-02-24T22\;13\;49.462087/adjustments.sqlite ~/.zipline/data/quandl/2019-02-24T22\;13\;49.462087/
}

alias opengdm="sudo service gdm start"

alias dk="xinput set-int-prop 8 \"Device Enabled\" 8 0"
alias ek="xinput set-int-prop 8 \"Device Enabled\" 8 1"

