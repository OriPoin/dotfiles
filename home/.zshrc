# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#--------------------------------Arch-----------------------------------------
#if [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
#  . /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
#fi

#-------------------------------Gentoo----------------------------------------
if [[ -f /usr/share/zsh/site-functions/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  . /usr/share/zsh/site-functions/powerlevel10k/powerlevel10k.zsh-theme
fi

# zsh syntax highlight
#--------------------------------Arch-----------------------------------------
#if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
#  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#fi
#-------------------------------Gentoo----------------------------------------
if [[ -f /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh ]]; then
  . /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
fi
# zsh autosuggestions
#--------------------------------Arch-----------------------------------------
#if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
#  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#fi
#-------------------------------Gentoo----------------------------------------
if [[ -f /usr/share/zsh/site-functions/zsh-autosuggestions.zsh ]]; then
  . /usr/share/zsh/site-functions/zsh-autosuggestions.zsh
fi

# Gentoo prompt for zsh
autoload -U promptinit
promptinit; prompt gentoo

#------------------------------
# History
#------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
#------------------------------
# Variables
#------------------------------
export EDITOR="vim"

#------------------------------
# Comp stuff
#------------------------------
zmodload zsh/complist 
autoload -Uz compinit
compinit
zstyle :compinstall filename '${HOME}/.zshrc'

zmodload -i zsh/complist
# Enable completion caching, use rehash to clear
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zshcache
# The name of the tag for the matches will be used as the name of the group
zstyle ':completion:*' group-name ''
# Menu friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
# When there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
# Completion menu
# select=num, menu selection will only be started if there are at least num matches.
zstyle ':completion:*' menu select=2 _complete _ignored _approximate
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# cd will never select the parent directory (e.g.: cd ../<TAB>)
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Completion for sudo when the command is not in the current path
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
#- buggy
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always
#------------------------------
# Keybindings
#------------------------------
bindkey -e
typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
#------------------------------
# Alias stuff
#------------------------------
# ls
# -v: natural sort of version
alias ls='ls                                  -v --classify --group-directories-first --color=auto'
alias  l='ls -l              --human-readable -v --classify --group-directories-first --color=auto'
alias ll='ls -l              --human-readable -v --classify --group-directories-first --color=auto'
alias la='ls -l --almost-all --human-readable -v --classify --group-directories-first --color=auto'
# Sudo
alias svim="sudo vim"
# More verbose fileutils
alias cp='nocorrect cp -iv' # -i to prompt for every file
alias mv='nocorrect mv -iv'
alias rm='nocorrect rm -Iv' # -I to prompt when more than 3 files
alias rmdir='rmdir -v'
alias chmod='chmod -v'
alias chown='chown -v'
# Parent directories
alias cd..='cd ..'
alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh




# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

