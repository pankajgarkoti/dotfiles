typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
export LANG='en_US.UTF-8'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fastfetch

# flutter and java path
export PATH='/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/pankajgarkoti/Desktop/code/flutter/bin:/Users/pankajgarkoti/Desktop/flutter/bin'
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# general shortcuts
alias la='ls -la'
alias ll='ls -l'

# ssh shortcuts
alias gtc='cd ~/Desktop/code'
alias gtz='cd ~/Desktop/code/work'
alias gtzb='cd ~/Desktop/code/work/backend'
alias gtzf='cd ~/Desktop/code/work/frontend'
alias gtn='cd ~/Desktop/notes'

# alias gtcs='cd ~/Desktop/code/server-keys'
alias gtcs1='gcloud compute ssh --zone "us-central1-a" "instance-2" --project "mavex-ai"' # commenting because i do not have access to this anymore
alias gtszb='ssh backend.devpod'

# git shortcuts
alias commit='git commit -m'
alias checkout='git checkout'
alias push='git push origin'
alias pull='git pull'
alias branch='git branch'
alias status='git status'
alias add='git add'

# tmux shortcuts
alias tmux0='tmux attach -t 0'
alias tmuxc='tmux attach -t code'
alias tmuxn0='tmux new -t 0'
alias tmuxnc='tmux new -t code'
alias tmuxl='tmux ls'
alias tm='gtc; tmuxc || tmuxnc'
alias lg="lazygit"

# why not?
alias :q='exit'

# python env activation
alias activate='{ source .env/bin/activate; echo "Python virtual environment activated (.env)" } || { source .venv/bin/activate; echo "Python virtual environment activated (.venv)" }'
alias run='{ python3 main.py } || { python3 run.py } || { python3 app.py } || { python3 runner.py }'

# backup notes to github
alias savenotes='cd ~/Desktop/notes; git add .; commit "$(date)"; push main; echo "~/Desktop/notes/work has been backed up to GitHub :)"'

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

alias firefox=/Applications/Firefox.app/Contents/MacOS/firefox-bin
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# neofetch
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/pankajgarkoti/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/pankajgarkoti/Downloads/google-cloud-sdk/path.zsh.inc'; fi
#
# # The next line enables shell command completion for gcloud.
if [ -f '/Users/pankajgarkoti/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/pankajgarkoti/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

function set_run_alias() {
    if [[ -f "pyproject.toml" ]]; then
        # Poetry project
        alias run="poetry run"
    elif [[ -f "package.json" ]]; then
        # Node.js project
        alias run="npm run"
    elif [[ -f "*.py" ]]; then
        # Python project
        alias run="python3"
    elif [[ -f "Gemfile" ]]; then
        # Ruby project with Bundler
        alias run="bundle exec"
    elif [[ -f "Makefile" ]]; then
        # Project with a Makefile
        alias run="make"
    elif [[ -f "docker-compose.yml" ]]; then
        # Docker Compose project
        alias run="docker-compose run"
    elif [[ -f "Vagrantfile" ]]; then
        # Vagrant project
        alias run="vagrant"
    elif [[ -f "build.gradle" || -f "build.gradle.kts" ]]; then
        # Gradle project (Java, Kotlin, etc.)
        alias run="gradle"
    elif [[ -f "pom.xml" ]]; then
        # Maven project (Java)
        alias run="mvn"
    else
        unalias run 2> /dev/null || true
    fi
}

# Automatically call the function when changing directories
autoload -U add-zsh-hook
add-zsh-hook chpwd set_run_alias

# Call the function initially
set_run_alias
alias build="run build"
alias dev="run dev"
alias uvicorn="run uvicorn main:app"
alias main="run python3 main.py"
alias mock="run python3 mock.py"

export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"

export OLLAMA_MODELS="/Volumes/spinny/ollama"
export DYLD_LIBRARY_PATH="/usr/local/opt/sqlite/lib:/usr/lib"
# source rust environment vars
source ~/.cargo/env

# required for gpg to work and signing commits
export GPG_TTY=$(tty)


# bun completions
[ -s "/Users/pankajgarkoti/.bun/_bun" ] && source "/Users/pankajgarkoti/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/pankajgarkoti/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export XDG_CONFIG_HOME="$HOME/.config"
export POETRY_VIRTUALENVS_IN_PROJECT=false
