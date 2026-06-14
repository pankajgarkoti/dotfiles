export LANG='en_US.UTF-8'

# export PROMPT='[ %1~ %# ] > '
# export PROMPT='[ %1~ %# ] > '
# Git info
autoload -Uz vcs_info

setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' max-exports 2
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{green}!'
zstyle ':vcs_info:git:*' unstagedstr '%F{green}?'
# %b -> branch, %c%u -> staged/unstaged markers (no spaces, kept tight)
zstyle ':vcs_info:git:*' formats ':%b' '%c%u'

git_untracked_marker() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

    [[ -n "$(git ls-files --others --exclude-standard 2>/dev/null | head -n1)" ]] &&
        echo '%F{green}+'
}

precmd() {
    vcs_info

    # Build the git segment: branch, plus a single leading space before the
    # marker group only when at least one marker is present.
    GIT_SEGMENT="${vcs_info_msg_0_}"
    local markers="${vcs_info_msg_1_}$(git_untracked_marker)"
    [[ -n "$markers" ]] && GIT_SEGMENT+=" ${markers}"

    if (( EUID == 0 )); then
        PROMPT_ARROW='%F{red}>%f'
    else
        PROMPT_ARROW='%F{green}>%f'
    fi
}

PROMPT='[ %F{cyan}%1~%f%F{242}${GIT_SEGMENT}%f ] ${PROMPT_ARROW} '

. ~/.config.setup.sh


# flutter and java path
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/development/android-sdk/cmdline-tools/latest/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

# Android SDK tools
# export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

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

run() {
    local files=("main.py" "run.py" "app.py" "runner.py")
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            python3 "$file"
            return $?
        fi
    done
    
    echo "No runnable Python file found (${files[*]})" >&2
    return 1
}

# backup notes to github
alias savenotes='cd ~/Desktop/notes; git add .; commit "$(date)"; push main; echo "~/Desktop/notes/work has been backed up to GitHub :)"'
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/pankajgarkoti/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/pankajgarkoti/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/pankajgarkoti/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/pankajgarkoti/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

function set_run_alias() {
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

export DYLD_LIBRARY_PATH="/usr/local/opt/sqlite/lib:/usr/lib"

# required for gpg to work and signing commits
export GPG_TTY=$(tty)

# pnpm
export PNPM_HOME="/Users/pankajgarkoti/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export XDG_CONFIG_HOME="$HOME/.config"
export POETRY_VIRTUALENVS_IN_PROJECT=false

# Added by Windsurf
export PATH="/Users/pankajgarkoti/.codeium/windsurf/bin:$PATH"

# Created by `pipx` on 2025-02-15 09:37:47
export PATH="$PATH:/Users/pankajgarkoti/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

alias monitor="/Users/pankajgarkoti/dotfiles/zsh/monitor.zsh"

# Fixes broken SQLITE
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig"

# Added by Antigravity
# alias sudoclaude='claude --dangerously-skip-permissions'

# alias qemu_ubuntu='qemu-system-x86_64 -machine type=pc,accel=tcg -m 4G -smp 2 -cpu max -drive file=ubuntu-server.qcow2,format=qcow2 -boot c -netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=n1 -serial mon:stdio -vga std -display cocoa'

# opencode
export PATH=/Users/pankajgarkoti/.opencode/bin:$PATH
source ~/.config.setup.sh

# bun completions
[ -s "/Users/pankajgarkoti/.bun/_bun" ] && source "/Users/pankajgarkoti/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# some flamboyance
fastfetch
