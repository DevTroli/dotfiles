# Integrando o MISE ao zsh
eval "$(/home/troli/.local/bin/mise activate zsh)"

# Deixando o terminal mais bonito com starship
eval "$(starship init zsh)"

# Setup enviroments
export EDITOR=nvim
export VISUAL="$EDITOR"

# Histórico aprimorado
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Autocompletar aprimorado
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=151,bold"

# Cores para syntaxe no zsh
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Adicionando super-poderes de busca ao shell com fzf
source <(fzf --zsh)

# echo $fpath | tr ' ' '\n'
# Coisas do Brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# setup from yazi (FileManager)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

BAT_THEME="Catppuccin Mocha"

# === ZSH Program Manager Plugin ===
# Carregar o plugin diretamente
if [[ -f "$HOME/.config/zsh/functions/zsh-program-manager/zsh-program-manager.plugin.zsh" ]]; then
    source "$HOME/.config/zsh/functions/zsh-program-manager/zsh-program-manager.plugin.zsh"
else
    echo "❌ ZPM não encontrado em $HOME/.config/zsh/functions/zsh-program-manager/"
fi

# === Personalização ZPM ===
# Interface FZF mais compacta
zstyle ':zpm:search' fzf-options '--height=50% --border=rounded --layout=reverse'

# Preview personalizado (opcional)
zstyle ':zpm:update' preview-command 'echo "Pacote: {1}" && echo "Carregando detalhes..."'

# audio do pipewire
export PIPEWIRE_LATENCY=512/48000

# Atalhos uteis para o shell
alias cat="bat --plain --theme-dark default --theme-light GitHub"
alias ls="exa --icons"
alias ps="procs"

alias fvim='nvim $(fzf -m --preview="bat --color=always {}")'
