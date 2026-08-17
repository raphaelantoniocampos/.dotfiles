# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

fastfetch

# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/raphaelac/zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey '^[[1;5D' backward-word     # Ctrl+Left
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^H' backward-kill-word     # Ctrl+Backspace
WORDCHARS=${WORDCHARS//\/[&.;]}

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Alias
alias cat="bat"
alias cd="z"
alias icat="kitty icat"
alias lg="lazygit"
alias trp="trash-put"
alias ls="lsd"
alias uvr="uv run"
alias pclean="sh ~/.scripts/pclean.sh"
alias rm='echo "This is not the command you are looking for, try trp. (If you really want it use \rm)"; false'
alias ff="fastfetch"
alias v="nvim"

# Old Suse alias
# alias zup="sudo -E sh ~/.config/scripts/zup.sh"
# alias zclean="sudo -E sh ~/.config/scripts/zclean.sh"
