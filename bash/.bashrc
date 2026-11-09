# Bash port of zsh/.zshrc. Works on Linux and macOS.

# Source global definitions (Fedora's default .bashrc did this)
[ -f /etc/bashrc ] && . /etc/bashrc

# ── Environment ──────────────────────────────────────────────────────────────
# Set for every shell: bash also reads this file for non-interactive ssh commands.
export LANG='en_US.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
export POETRY_VIRTUALENVS_IN_PROJECT=false

# Add a directory to PATH only if it exists and isn't already there.
__path_prepend() { [[ -d $1 && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; return 0; }
__path_append() { [[ -d $1 && ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; return 0; }

if [[ $OSTYPE == darwin* ]]; then
    __path_prepend /opt/homebrew/sbin
    __path_prepend /opt/homebrew/bin
    __path_prepend /opt/homebrew/opt/openjdk@11/bin
    __path_prepend /opt/homebrew/opt/openjdk/bin
    __path_prepend /Applications/Docker.app/Contents/Resources/bin
    export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig"
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
    export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
    export PNPM_HOME="$HOME/Library/pnpm"
    __path_prepend /opt/homebrew/opt/sqlite/bin
else
    export ANDROID_HOME="$HOME/Android/Sdk"
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi

# flutter and android
__path_prepend "$HOME/development/flutter/bin"
__path_prepend "$HOME/development/android-sdk/cmdline-tools/latest/bin"
__path_append "$ANDROID_HOME/emulator"
__path_append "$ANDROID_HOME/platform-tools"

# language and tool managers
__path_prepend "$PNPM_HOME"
__path_prepend "$HOME/.codeium/windsurf/bin"
__path_prepend "$HOME/bin"
__path_prepend "$HOME/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
__path_prepend "$PYENV_ROOT/bin"
__path_prepend "$HOME/.opencode/bin"
export BUN_INSTALL="$HOME/.bun"
__path_prepend "$BUN_INSTALL/bin"
export PATH

# ── Everything below is for interactive shells only ──────────────────────────
case $- in
*i*) ;;
*) return ;;
esac

# Fedora's drop-in directory for user snippets
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
    unset rc
fi

# ── Prompt: [ dir:branch !?+ ] > ─────────────────────────────────────────────
# ! staged, ? unstaged, + untracked
__set_git_segment() {
    GIT_SEGMENT=""
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    local branch markers="" green=$'\001\e[32m\002'
    branch=$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    git diff --cached --no-ext-diff --quiet 2>/dev/null || markers+="${green}!"
    git diff --no-ext-diff --quiet 2>/dev/null || markers+="${green}?"
    [[ -n "$(git ls-files --others --exclude-standard 2>/dev/null | head -n1)" ]] && markers+="${green}+"

    GIT_SEGMENT=":${branch}"
    [[ -n $markers ]] && GIT_SEGMENT+=" ${markers}"
}

# Runs before each prompt. Bash has no chpwd hook, so directory changes are
# detected here; that also catches pushd, popd and autocd, not just cd.
__prompt_command() {
    local last_status=$?
    if [[ $PWD != "${__LAST_PWD-}" ]]; then
        __LAST_PWD=$PWD
        set_run_alias
    fi
    __set_git_segment
    if ((EUID == 0)); then
        PROMPT_ARROW=$'\001\e[31m\002>\001\e[39m\002'
    else
        PROMPT_ARROW=$'\001\e[32m\002>\001\e[39m\002'
    fi
    return $last_status
}

# Git data stays in variables, not PS1 itself, so a branch named `$(cmd)` is
# printed rather than executed.
PS1='[ \[\e[36m\]\W\[\e[39m\]\[\e[38;5;242m\]${GIT_SEGMENT}\[\e[39m\] ] ${PROMPT_ARROW} '

# /etc/profile.d can set PROMPT_COMMAND as a string or an array; keep its entries.
# The checks stop it being added twice when ~/.bashrc is re-sourced.
if [[ "$(declare -p PROMPT_COMMAND 2>/dev/null)" == "declare -a"* ]]; then
    [[ " ${PROMPT_COMMAND[*]} " == *" __prompt_command "* ]] || PROMPT_COMMAND=(__prompt_command "${PROMPT_COMMAND[@]}")
elif [[ $PROMPT_COMMAND != *__prompt_command* ]]; then
    PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
fi

# ── Aliases ──────────────────────────────────────────────────────────────────
# general shortcuts
alias la='ls -la'
alias ll='ls -l'

# ssh shortcuts
alias gtc='cd ~/Desktop/code'
alias gtn='cd ~/Desktop/notes'

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

# backup notes to github
alias savenotes='cd ~/Desktop/notes; git add .; commit "$(date)"; push main; echo "~/Desktop/notes/work has been backed up to GitHub :)"'

alias monitor="$HOME/dotfiles/bash/monitor.sh"

# ── Functions ────────────────────────────────────────────────────────────────
# python env activation
activate() {
    if [[ -f ".env/bin/activate" ]]; then
        source ".env/bin/activate"
        echo "Python virtual environment activated (.env)"
    elif [[ -f ".venv/bin/activate" ]]; then
        source ".venv/bin/activate"
        echo "Python virtual environment activated (.venv)"
    else
        echo "No virtual environment found (.env or .venv)" >&2
        return 1
    fi
}

# An active `run` alias would break this definition when re-sourcing ~/.bashrc.
# Clearing __LAST_PWD makes the next prompt set the alias again.
unalias run 2>/dev/null
unset __LAST_PWD
run() {
    local files=("main.py" "run.py" "app.py" "runner.py")
    local file

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            python3 "$file"
            return $?
        fi
    done

    echo "No runnable Python file found (${files[*]})" >&2
    return 1
}

set_run_alias() {
    if [[ -f "pyproject.toml" ]]; then
        # Poetry project
        alias run="uv run"
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
        unalias run 2>/dev/null || true
    fi
}

alias build="run build"
alias dev="run dev"
alias uvicorn="run uvicorn main:app"
alias main="run python3 main.py"
alias mock="run python3 mock.py"

# required for gpg to work and signing commits
export GPG_TTY=$(tty)

# ── Integrations (each one is optional) ──────────────────────────────────────
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - bash)"
[ -f ~/.config.setup.sh ] && . ~/.config.setup.sh
[ -f ~/.config/alacritty_theme.bash ] && . ~/.config/alacritty_theme.bash

# some flamboyance
command -v fastfetch >/dev/null 2>&1 && fastfetch
:

# opencode
export PATH=/home/pankajgarkoti/.opencode/bin:$PATH

# MAGI boot banner: top-level interactive terminals only (not every tmux pane), and the MAGI scratchpad
if [[ $- == *i* ]] && command -v magi-banner >/dev/null && { [ -z "$TMUX" ] || [ "$(tmux display-message -p '#S' 2>/dev/null)" = magi ]; }; then
  magi-banner
fi
