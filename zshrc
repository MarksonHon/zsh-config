if command -v /usr/local/bin/brew > /dev/null; then
    brew_prefix="$(/usr/local/bin/brew --prefix)"
    eval "$(/usr/local/bin/brew shellenv)"
elif command -v /opt/homebrew/bin/brew > /dev/null; then
    brew_prefix="$(/opt/homebrew/bin/brew --prefix)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif command -v /home/linuxbrew/.linuxbrew/bin/brew > /dev/null; then
    brew_prefix="$(/home/linuxbrew/.linuxbrew/bin/brew --prefix)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

## Set alias 
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias ls='ls --color=auto'                                      # Set colored output of ls
alias ip='ip -c'

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$brew_prefix"/share/zsh-syntax-highlighting/highlighters

source "$brew_prefix"/share/powerlevel10k/powerlevel10k.zsh-theme
source "$brew_prefix"/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source "$brew_prefix"/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source "$brew_prefix"/share/zsh-history-substring-search/zsh-history-substring-search.zsh


# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
        autoload -Uz add-zle-hook-widget
        function zle_application_mode_start { echoti smkx }
        function zle_application_mode_stop { echoti rmkx }
        add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
        add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
