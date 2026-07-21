HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v

ZSH_THEME=alanpeabody

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-antidote/antidote.zsh

export EDITOR="nvim"
export VISUAL="nvim --noplugin"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

alias editplugins="$EDITOR ~/.zsh_plugins.txt"
alias editzsh="$EDITOR ~/.zshrc"

alias j="z"
alias jj="zi"
alias lg="lazygit"
alias winboot="windows-reboot"

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

alias bwu='export BW_SESSION=$(bw unlock --raw)'

bwensure() {
  if [ -z "$BW_SESSION" ]; then
    echo "Unlocking Bitwarden..."
    export BW_SESSION=$(bw unlock --raw)
    bw sync
  fi
}

bwp() {
  bwensure

  local items=$(bw list items --search "${1:-}")

  local selected=$(printf '%s' "$items" \
    | jq -r '.[] |
      "🔐 \(.name)\t👤 \(.login.username // "no username")\t🌐 \(.login.uris[0].uri // "no url")"' \
    | fzf \
        --exact \
        --ignore-case \
        --delimiter='\t' \
        --with-nth=1,2,3 \
        --height=40% \
        --border \
        --preview 'echo -e "\n🔐 {1}\n👤 {2}\n🌐 {3}\n\n📋 Password will be copied on select"' \
        --preview-window=right:40%)

  [ -z "$selected" ] && return

  local name=$(printf '%s' "$selected" | awk -F'\t' '{print $1}' | sed 's/^🔐 //')

  printf '%s' "$items" \
    | jq -r --arg name "$name" '.[] | select(.name == $name) | .login.password' \
    | copyq copy -

  echo "📋 Copied: $name"
}

# bun completions
[ -s "/home/sul/.bun/_bun" ] && source "/home/sul/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
