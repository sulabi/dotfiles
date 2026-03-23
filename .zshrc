HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v

ZSH_THEME=alanpeabody

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.antidote/antidote.zsh

export EDITOR="nvim"
export VISUAL="nvim"

alias editplugins="$EDITOR ~/.zsh_plugins.txt"
alias editzsh="$EDITOR ~/.zshrc"

alias j="z"
alias jj="zi"
alias lg="lazygit"

antidote load

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.npm-global/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
