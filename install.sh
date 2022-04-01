#!/bin/bash
# mac-devops-setup DevOps MACOS Development Setup
# https://github.com/gonzaloacosta/mac-devops-setup
#
# Copyright (c) Gonzalo Acosta

VERSION="0.0.1"
PREFIX="${HOME}"

red="\033[91m%b\033[39m"
green="\033[92m%b\033[39m"
magenta="\033[95m%b\033[39m"

set -euo pipefail

usage() {
cat <<EOF
    ----------------------------------------------------------------------------
    Mac DevOps Tools
    ----------------------------------------------------------------------------

	Usage:  $ install [OPTIONS]
            $ install xcode basic git zsh tmux python vim kubernetes aws

    Options
    ----------------------------------------------------------------------------
    version
    help
    xcode
    basic
    git
    gitconfig
    bash
    bashconfig
    zsh
    tmux
    python
    pydatascience
    pyaws
    vscode
    vim
    iterm2
    docker
    kubernetes
    aws
    terraform
    java
    devtools
    node
    golang
    database
    docker
    parallels

    ----------------------------------------------------------------------------
    By Gonzalo Acosta @gonzaloacosta
    ----------------------------------------------------------------------------
EOF
}

print_version() {
	printf "mac-devops-setup install ${VERSION}\n"
}

usage_fatal() {
    usage
    printf "${red}" "\nError: "
    printf "Illegal option!\n"
}

wait_for_user() {
    printf "\nPress RETURN to continue or any other key to abort!\n"

    read -rsn 1 key
    if [[ ${key} != "" ]]; then
        exit 0
    fi
}

wait_for_sudo() {
    trap "exit 1" SIGINT # Process Interruption Ctrl-C

    # Check if sudo password has been entered
    # If not, request sudo password
    if sudo -vn 2>/dev/null; then
        printf "${magenta}" "\n[sudo] this script is using sudo privileges!\n\n"
    else
        printf "\n[sudo] Enter password for ${USER}\n"
        sudo -v
    fi

    # Abort if no sudo privileges
    if ! sudo -vn 2>/dev/null; then
        printf "${red}" "Aborted: "
        printf "this script needs sudo privileges!\n"
        exit 1
    fi
}

homebrew_update() {
    if command -v brew &>/dev/null; then
        printf "${magenta}" "Updating Homebrew!\n"
        brew update
    else
        BREW_URL='/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'

        printf "Homebrew is required for the installation.\n\n"
        printf "Install homebrew using the following command:\n"
        printf "${BREW_URL}\n"
        printf "${red}" "\nError: "
        printf "Homebrew is not installed!\n"
        exit 1
    fi
}

xcode_install() {

	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Step 1: Update the OS and Install Xcode Tools
	printf "${magenta}" "\nUpdating OSX.  If this requires a restart, run the script again.\n"
	# Install all available updates
	#sudo softwareupdate -ia --verbose
	# Install only recommended available updates
	#sudo softwareupdate -ir --verbose

	printf "${magenta}" "\nInstalling Xcode Command Line Tools.\n"
	xcode-select --install

}

git_config() {
	printf "${magenta}" "\nSet up Git - Ctrl+C to cancel\n"

	printf "git config --global user.name 'Your name': "
	read -r GIT_USER_NAME

	printf "git config --global user.email 'your@email.com': "
	read -r GIT_USER_EMAIL

	# Confirm user input
	printf "${magenta}" "\nUser Name: "
	printf "${GIT_USER_NAME}\n"
	printf "${magenta}" "E-mail   : "
	printf "${GIT_USER_EMAIL}\n"

	wait_for_user

	# Set git user name and email
	git config --global user.name "${GIT_USER_NAME}"
	git config --global user.email "${GIT_USER_EMAIL}"

	# Set git terminal colors
	git config --global color.ui true
	git config --global color.status.changed "blue normal"
	git config --global color.status.untracked "red normal"
	git config --global color.status.added "magenta normal"
	git config --global color.status.updated "green normal"
	git config --global color.status.branch "yellow normal bold"
	git config --global color.status.header "white normal bold"

	# Add alias
	printf "${magenta}" "\nInstall git aliases"
	#TODO

	printf "${magenta}" "\nInstall git-secrets"
	git secrets --register-aws --global
	git secrets --install ~/.git-templates/git-secrets
	git config --global init.templateDir ~/git-templates/git-secrets

  printf "${green}" "\nGit setup completed.\n"
}

git_install() {
	printf "${magenta}" "Install and set up Git!\n"

	homebrew_update

	printf "${magenta}" "Installing Git!\n"
	brew install git || true
	brew install git-secrets

	git_config

	git_alias

	printf "${green}" "\nGit installation successful.\n"
}

basic_packages_install() {
	printf "${magenta}" "\nInstall basic packages\n"

	homebrew_update

	brew install curl
	brew install tree
	brew install ack
	brew install jq
	brew install htop
	brew install tldr
	brew install coreutils
	brew install watch
	brew install netcat
	brew install iproute2mac
	brew install bat
	brew install exa
	brew install fzf
	brew install lastpass-cli
	brew install autojump 		# fast filesystem navigation
	brew install speedtest-cli

}

###############################################################################
set +e

# INPUTRC
read -r -d '' INPUTRC <<EOF
"\e[A":history-search-backward
"\e[B":history-search-forward
set colored-stats on
set mark-symlinked-directories on
set show-all-if-ambiguous on
set show-all-if-unmodified on
set visible-stats on
set completion-ignore-case on
TAB: menu-complete
EOF

# BASH_PROFILE
read -r -d '' BASH_PROFILE <<"EOF"
#!/bin/bash
# Bash Profile for macOS

# LS Colors
# CLICOLOR use ANSI color sequences to distinguish file types
export CLICOLOR=true
export LSCOLORS=gxegbxdxcxahadabafacge
alias ls='ls -GFh'

# Bash Colors and formatting
CYAN="\[\e[38;5;6m\]"
MAGENTA="\[\e[38;5;13m\e[1m\]"
SKYBLUE="\[\e[38;5;25m\e[1m\]"
NONE="\[\e[0m\e[21m\]"

# Prevent Mac OS ._ in in tar.gz files
export COPYFILE_DISABLE=true

# Homebrew
export PATH="/usr/local/bin:${PATH}"

# Homebrew completion
if [[ -f "$(brew --prefix)/etc/bash_completion.d/brew" ]]; then
    source "$(brew --prefix)/etc/bash_completion.d/brew"
fi

# Bash completion@2
if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

# Bash-Git-prompt
if [[ -f "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh" ]]; then
    GIT_PS1_SHOWCOLORHINTS=true
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_DESCRIBE_STYLE='default'
    source "$(brew --prefix)/etc/bash_completion.d/git-prompt.sh"
fi

# exa is a replacement for ls https://github.com/ogham/exa
if command -v exa 1>/dev/null 2>&1; then
    alias ls="exa --icons --group-directories-first --classify"
fi

# Python virtual environment
# Allow pip only for active virtual environment
# Use 'gpip' for global environment
export PIP_REQUIRE_VIRTUALENV=true
gpip(){
    PIP_REQUIRE_VIRTUALENV="" pip "${@}"
}

gpip3(){
    PIP_REQUIRE_VIRTUALENV="" pip3 "${@}"
}

# Pyenv Python version management
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper
fi

# PRIMARY PROMPT
PROMPT_COMMAND='__git_ps1\
                "\n${MAGENTA}[\d \t] ${SKYBLUE}$(python --version 2>&1)${NONE}\
                \n\u@\h: ${CYAN}\w${NONE}"\
                "\n${VIRTUAL_ENV:+($(basename ${VIRTUAL_ENV}))}\\$ "\
                "(%s)"'
EOF

bash_config() {
    printf "${magenta}" "Set up and improve Bash\n"

    printf "${magenta}" "Set up the command line history search\n"
    echo "${INPUTRC}" > "${HOME}/.inputrc"

    printf "${magenta}" "Backup the current .bash_profile file\n"
    if [[ -f "${HOME}/.bash_profile" ]]; then
        cp "${HOME}/.bash_profile" "${HOME}/.bash_profile.bkp"
    fi

    printf "${magenta}" "Update the .bash_profile\n"
    echo "${BASH_PROFILE}" > "${HOME}/.bash_profile"

    printf "${magenta}" "Install bash-completion\n"
    brew install bash-completion@2

    printf "${magenta}" "Install docker command-line completion\n"
    brew install docker-completion docker-machine-completion docker-compose-completion

    printf "${magenta}" "Install exa\n"
    brew install exa

    printf "${green}" "\nBash setup completed.\n"
}

bash_install() {
    printf "${magenta}" "Update and set up Bash as the default shell\n"

    wait_for_sudo
    homebrew_update
    brew install bash

    if $(grep -Fxq "/opt/homebrew/bin/bash" /etc/shells); then
        printf "${magenta}" "The list of shells is already updated!\n"
    else
        printf "${magenta}" "Adding the new shell to the list of allowed shells\n"
        sudo echo "/opt/homebrew/bin/bash" >> /etc/shells
    fi

    printf "${magenta}" "Changing to the new shell\n"
    chsh -s "/opt/homebrew/bin/bash"

    bash_config

    printf "${green}" "\nBash installation successful!\n"

    printf "${magenta}" "\nClose and reopen the Terminal!\n"
}


###############################################################################
set +e

# ZSH_PROFILE
read -r -d '' ZSH_PROFILE <<"EOF"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Test the performance of zsh
#zmodload zsh/zprof

# -------------------------------------------------
# POWERLEVEL 10K THEME SETTINGS
# -------------------------------------------------
POWERLEVEL9K_MODE="nerdfont-complete"

# Current directory
POWERLEVEL9K_DIR_FOREGROUND=254
POWERLEVEL9K_DIR_BACKGROUND=237

# OS identifier color
POWERLEVEL9K_OS_ICON_FOREGROUND=232
POWERLEVEL9K_OS_ICON_BACKGROUND=7

# Time
POWERLEVEL9K_TIME_FOREGROUND=0
POWERLEVEL9K_TIME_BACKGROUND=7
POWERLEVEL9K_TIME_FORMAT="%D{%d/%m %H:%M:%S}"

# Current Python virtual environment
POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
POWERLEVEL9K_VIRTUALENV_BACKGROUND=220

# Pyenv
POWERLEVEL9K_PYENV_FOREGROUND=255
POWERLEVEL9K_PYENV_BACKGROUND=24

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    newline
    prompt_char
)

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    direnv
    asdf
    virtualenv
    pyenv
    vim_shell
    time
    newline
)

# NeedTree Git
GIT_UNCOMMITTED="+"
GIT_UNSTAGED="!"
GIT_UNTRACKED="?"
GIT_STASHED="$"
GIT_UNPULLED="⇣"
GIT_UNPUSHED="⇡"

# Path to oh-my-zsh installation
export ZSH="${HOME}/.oh-my-zsh"

# ZSH Terminal title
DISABLE_AUTO_TITLE=true

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    gitfast
    git-extras
    git-flow
    pip
    pipenv
    virtualenv
    command-not-found
    autojump
    common-aliases
    compleat
    z
    vi-mode
    aws
    terraform
    ansible
    docker
    docker-compose
    colorize
    colored-man-pages
    minikube
		kops
    kubectl
    kubectx
    kube-ps1
    cp
    history
    nmap
    fzf
    macos
    web-search
    last-working-dir
    lpass
    vagrant
    ssh-agent
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# TODO configure

# Update ZSH settings
source $ZSH/oh-my-zsh.sh

# setting this explicitly in order to autocomplete '..' -> '../'
setopt autoparamslash
setopt auto_remove_slash
setopt +o nomatch
bindkey -v
bindkey '^R' history-incremental-search-backward

# % Character
# unsetopt PROMPT_SP
export PROMPT_EOL_MARK=''

# Load custom aliases
[[ -s "$HOME/.shell/aliases.sh" ]] && source "$HOME/.shell/aliases.sh"

# Load os exports
[[ -s "$HOME/.shell/os_export.sh" ]] && source "$HOME/.shell/os_export.sh"

# Load os functions
[[ -s "$HOME/.shell/functions.sh" ]] && source "$HOME/.shell/functions.sh"

#DISABLE_MAGIC_FUNCTIONS=true
autoload -U +X compinit && compinit

# AWS plugin
ZSH_THEME_AWS_PREFIX='aws:'
ZSH_THEME_AWS_SUFFIX=' '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export PATH="/usr/local/opt/libpq/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Not error when load zsh
POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLEVEL9K_INSTANT_PROMPT=off

# ZSH Completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi
EOF

set -e
###############################################################################

zsh_install() {
    printf "${magenta}" "Set up Oh My Zsh + Powerlevel9k + Nerd font\n"
    homebrew_update
    printf "${magenta}" "Update and select Zsh as the default shell\n"
		brew install zsh
		printf "${magenta}" "Add the new shell to the list of allowed shells\n"
		if $(grep -Fxq "/bin/zsh" /etc/shells); then
			printf "${magenta}" "The list of shells is already updated!\n"
		else
			wait_for_sudo
			echo "/bin/zsh" | sudo tee -a /etc/shells
		fi
		printf "${magenta}" "Change to the new shell\n"

		chsh -s "/bin/zsh"
		printf "${magenta}" "Install Oh My Zsh\n"

		URL="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
		sh -c "$(curl -fsSL ${URL}) --unattended"

		printf "${magenta}" "Install Nerd Font\n"
		brew tap homebrew/cask-fonts
		brew install font-hack-nerd-font

		printf "${magenta}" "Install Powerlevel10k theme\n"
		URL="https://github.com/romkatv/powerlevel10k.git"
		DIR="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
		git clone "${URL}" "${DIR}"

		printf "${magenta}" "Install zsh-autosuggestions\n"
		URL="https://github.com/zsh-users/zsh-autosuggestions"
		DIR="${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
		git clone "${URL}" "${DIR}"

		printf "${magenta}" "Install syntax highlighting\n"
		URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"
		DIR="${ZSH_CUSTOM}:-${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
		git clone "${URL}" "${DIR}"

		printf "${magenta}" "Install exa\n"
		brew install exa printf "${magenta}" "Backup the current .zshrc file\n"
		if [[ -f "${HOME}/.zshrc" ]]; then
			cp "${HOME}/.zshrc" "${HOME}/.zshrc.bkp"
		fi
    printf "${magenta}" "Update the .zshrc\n"

		echo "${ZSH_PROFILE}" > "${HOME}/.zshrc"
		printf "${magenta}" "Set configuration for compinit\n"
		compaudit | xargs chown -R "$(whoami)" compaudit | xargs chmod g-w

    printf "${green}" "\nZsh installation successful!\n"
}

python_install() {
    printf "${magenta}" "Install Pyenv and Python 3.8.10\n"

    homebrew_update

    printf "${magenta}" "Install Pyenv\n"
    brew install pyenv
    brew install pyenv-virtualenvwrapper

    printf "${magenta}" "Install Python 3.8.10\n"
    eval "$(pyenv init -)"
    PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.8.10

    printf "${magenta}" "Set Python 3.8.10 as default\n"
    pyenv global 3.8.10
    pyenv virtualenvwrapper

    printf "${green}" "\nPython installation successful!\n"
}

pydatascience() {
    printf "${magenta}" "Install Python packages for data science\n"

    homebrew_update

    printf "${magenta}" "Install dependencies\n"
    brew install Graphviz

    printf "${magenta}" "Create a Python virtual environment\n"
    set +u
    eval "$(pyenv init -)"
    pyenv global 3.8.10
    pyenv virtualenvwrapper
    mkvirtualenv py38 || true
    set -u
    pip install --upgrade pip

    printf "${magenta}" "Install TensorFlow\n"
    pip install tensorflow

    printf "${magenta}" "Install Keras\n"
    pip install h5py pydot keras

    printf "${magenta}" "Install Python scientific libraires\n"
    pip install numpy \
                pandas \
                scipy \
                pillow \
                scikit-learn \
                scikit-image \
                sk-video

    printf "${magenta}" "Install basic libraires\n"
    pip install autopep8 \
                Cython \
                ipykernel \
                progressbar2 \
                pydocstyle \
                pylint \
                pytest \
                requests \
                markdown

    printf "${magenta}" "Install Matplotlib\n"
    pip install ipympl matplotlib

    # Fix Matplotlib backend
    mkdir -p "${HOME}/.config/matplotlib"
    echo "backend : TkAgg" > "${HOME}/.config/matplotlib/matplotlibrc"

    printf "${magenta}" "Install Node\n"
    brew install node || true

    printf "${magenta}" "Install Jupyter Lab\n"

    pip install jupyterlab jupyterlab_widgets ipywidgets

    pip install tensorboard jupyter-tensorboard jupytext

    jupyter labextension list

    printf "${green}" "\nPython setup completed.\n"
}


###############################################################################
set +e

# TMUX_CONF
read -r -d '' TMUX_CONF <<"EOF"
# ------------------------------------------------------------
# Tmux configuration
# ------------------------------------------------------------

setw -g mouse on
set -g automatic-rename
set -g base-index 1
set -g clock-mode-style 24
set -g default-terminal "screen-256color"
set -g display-time 4000
set -g history-limit 300000
set -g prefix C-a
set -g renumber-windows on
set -g set-clipboard on
set -g set-titles on
set -g status-keys vi
set -g terminal-overrides "*88col*:colors=88,*256col*:colors=256,xterm*:XT"
set -s escape-time 0
set -s focus-events on

#set -ga update-environment "GPG_AGENT_INFO"

setw -g automatic-rename on
setw -g monitor-activity on
setw -g xterm-keys on
setw -q -g utf8 on

# Quiet
#set -g visual-activity off
#set -g visual-bell off
#set -g visual-silence off
#setw -g monitor-activity off
#set -g bell-action none

# ------------------------------------------------------------
# Tmux Keybinding
# ------------------------------------------------------------

unbind C-b
unbind r
unbind %

bind r source-file ~/.tmux.conf
bind | split-window -h
bind - split-window -v

bind [ copy-mode
bind ] paste-buffer

bind -r C-h resize-pane -L
bind -r C-j resize-pane -D
bind -r C-k resize-pane -U
bind -r C-l resize-pane -R

bind -r h select-pane -L  # move left
bind -r j select-pane -D  # move down
bind -r k select-pane -U  # move up
bind -r l select-pane -R  # move right

# Shift arrow to change window
bind -n S-Left  previous-window
bind -n S-Right next-window

# ------------------------------------------------------------
# Status Bar
# ------------------------------------------------------------

set-option -g status-justify left
set-option -g status-left-length 13
set-option -g status-right-length 13

# One Dark Plugin
set -g @onedark_widgets "#(date +%s)"
set -g @onedark_time_format "%I:%M %p"
set -g @onedark_date_format "%D"

set -g status-interval 5

set -g window-style 'fg=default,bg=default'
set -g window-active-style 'fg=default,bg=default'

# ------------------------------------------------------------
# Plugins
# ------------------------------------------------------------

#set -g @plugin 'dracula/tmux'
set -g @plugin 'odedlaz/tmux-onedark-theme'
#set -g @plugin "arcticicestudio/nord-tmux"
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'tmux-plugins/tmux-online-status'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-urlview'
set -g @plugin 'tmux-plugins/tmux-fpp'
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-pugins/tmuxp'
set -g @plugin 'tmux-plugins/tpm'

# Initialized tmux plugin manager
run -b '~/.tmux/plugins/tpm/tpm'
EOF

tmux_install() {
	printf "${magenta}" "\nInstall and configure Terminal Multiplexer\n"
	brew install tmux tmux-mem-cpu-load tmuxinator-completion tmuxinator tmux-xpanes


	printf "${magenta}" "\nInstall Tmux Plugin Manager\n"
	mkdir -p ${HOME}/.tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  printf "${magenta}" "Update the .zshrc\n"
  echo "${TMUX_CONFIG}" > "${HOME}/.tmux.conf"

  printf "${green}" "\nTmux installation successful!\n"
}

pyaws() {
	echo "TODO"
}


###############################################################################
set +e

# VSCODE_SETTINGS
read -r -d '' VSCODE_SETTINGS <<"EOF"
{
    "terminal.integrated.fontFamily": "Hack Nerd Font",
    "terminal.integrated.fontSize": 14,

    "window.zoomLevel": 0,

    "editor.fontSize": 16,
    "editor.rulers": [80, 120],
    "editor.renderWhitespace": "all",
    "editor.renderControlCharacters": true,
    "editor.wordWrap":"on",

    "[markdown]": {
        "editor.defaultFormatter": "yzhang.markdown-all-in-one"
    },
    "markdown-pdf.highlightStyle": "github.css",
    "cSpell.language": "en,es",

    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.latex.autoBuild.run": "never",
    "latex-workshop.latex.outDir": "./build/",
    "latex-workshop.latex.recipes": [
        {
            "name": "latexmk",
            "tools": ["latexmk"]
        },
        {
            "name": "pdflatex -> bibtex -> pdflatex*2",
            "tools": ["pdflatex","bibtex","pdflatex","pdflatex"]
        },
        {
            "name": "pdflatex -> biber -> pdflatex*2",
            "tools": ["pdflatex","biber","pdflatex","pdflatex"]
        },
        {
            "name": "pdflatex -> glossaries -> bibtex -> pdflatex*2",
            "tools": ["pdflatex","makeglossaries","bibtex","pdflatex","pdflatex"]
        },
        {
            "name": "pdflatex -> glossaries -> biber -> pdflatex*2",
            "tools": ["pdflatex","makeglossaries","biber","pdflatex","pdflatex"]
        }
    ],

    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-output-directory=build",
                "-file-line-error",
                "-pdf",
                "%DOC%"
            ]
        },
        {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "-output-directory=build",
                "%DOC%"
            ]
        },
        {
            "name": "makeglossaries",
            "command": "makeglossaries",
            "args": ["-d","./build","%DOCFILE%"]
        },
        {
            "name": "bibtex",
            "command": "bibtex",
            "args": ["./build/%DOCFILE%"]
        },
        {
            "name": "biber",
            "command": "biber",
            "args": ["./build/%DOCFILE%"]
        }
    ],

    "python.venvPath": "~/.virtualenvs/",
}
EOF

set -e
###############################################################################

vscode_install() {

	homebrew_update

	printf "${magenta} Install Visual Studio Code"
	brew install --cask visual-studio-code

    if ! command -v code &>/dev/null; then
        printf "${red}" "Error: "
        printf "Visual Studio Code is not installed!\n"
        printf "Install it from https://code.visualstudio.com\n"
        exit 1
    fi

    printf "${magenta}" "Installing VS Code extensions\n"
    # code --list-extensions | xargs -L 1 echo code --install-extension
    code --install-extension aaron-bond.better-comments
    code --install-extension bierner.markdown-emoji
    code --install-extension bierner.markdown-preview-github-styles
    code --install-extension christian-kohler.path-intellisense
    code --install-extension CoenraadS.bracket-pair-colorizer-2
    code --install-extension DavidAnson.vscode-markdownlint
    code --install-extension dbaeumer.jshint
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension donjayamanne.githistory
    code --install-extension eamodio.gitlens
    code --install-extension ecmel.vscode-html-css
    code --install-extension eg2.vscode-npm-script
    code --install-extension esbenp.prettier-vscode
    code --install-extension humao.rest-client
    code --install-extension James-Yu.latex-workshop
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-python.python
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-vscode-remote.remote-ssh-edit
    code --install-extension ms-vscode.cmake-tools
    code --install-extension jock.svg
    code --install-extension cssho.vscode-svgviewer
    code --install-extension ms-vscode.cpptools
    code --install-extension msjsdiag.debugger-for-chrome
    code --install-extension msjsdiag.vscode-react-native
    code --install-extension oderwat.indent-rainbow
    code --install-extension redhat.vscode-yaml
    code --install-extension ritwickdey.LiveServer
    code --install-extension streetsidesoftware.code-spell-checker
    code --install-extension streetsidesoftware.code-spell-checker-french
    code --install-extension twxs.cmake
    code --install-extension VisualStudioExptTeam.vscodeintellicode
    code --install-extension yzane.markdown-pdf
    code --install-extension yzhang.markdown-all-in-one

        # VIM plugins
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
    defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
    defaults write com.microsoft.VSCodeExploration ApplePressAndHoldEnabled -bool false
    defaults delete -g ApplePressAndHoldEnabled
    if command -v git &>/dev/null; then
        printf "${magenta}" "Configuring vscode as default git editor\n"
        git config --global core.editor 'code --wait'

        printf "${magenta}" "Configuring vscode as default git diff tool\n"
        git config --global diff.tool vscode
        git config --global difftool.vscode.cmd 'code --wait --diff ${LOCAL} ${REMOTE}'
    fi

    printf "${magenta}" "Update VS Code settings\n"
    DIR="${HOME}/Library/Application Support/Code/User/settings.json"
    echo "${VSCODE_SETTINGS}" > "${DIR}"

    printf "${green}" "\nVS Code configured successful.\n"
}

vim_install() {

    homebrew_update

    printf "${magenta}" "Install NeoVIM tools\n"
    brew install neovim
    pip install --user --upgrade neovim

    printf "${magenta}" "Install Plug, plugin manager"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    printf "${magenta}" "Move all dotfiles from local to ${HOME}"
    cp -pvr ./.config/nvim ${HOME}/.config/

    printf "${green}" "VIM Installed"

}

term2_install() {

    homebrew_update

    printf "${magenta}" "Install iTerm2\n"
    brew install iterm2

}

docker_install() {
	echo "TODO"
}

kubernetes_install() {

    printf "${magenta}" "Install Kuberntes tools\n"

	brew install kube-ps1
	brew install kubectl
	brew install kubens
	brew install kubectl
	brew install stern
	brew install helm

}


###############################################################################
set +e

read -r -d '' BASH_MY_AWS<<"EOF"
export PATH="$PATH:$HOME/.bash-my-aws/bin"
source ~/.bash-my-aws/aliases

# For ZSH users, uncomment the following two lines:
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

source ~/.bash-my-aws/bash_completion.sh
EOF

aws_install() {

    printf "${magenta}" "Install AWS Client\n"
	brew install awscli
	brew install saml2aws

    printf "${magenta}" "Install bash-my-aws\n"
	URL=https://github.com/bash-my-aws/bash-my-aws.git
	DIR=~/.bash-my-zsh
	git clone ${URL} ${DIR}

    ${ZSHDIR}="${HOME}/.zshrc"
    echo "${BASH_MY_AWS}" >> "${ZSHDIR}"

    printf "${green}" "\nVS Code configured successful.\n"

}

hashicorp_install() {
	printf "${magenta}" "\n Install OpenJDK9 and OpenJDK11"
	homebrew_update

	brew install terraform
	brew install packer
	brew install vagrant

}

java_install() {
	printf "${magenta}" "\n Install OpenJDK9 and OpenJDK11"
	homebrew_update

	# Install OpenJDK11 by default
	brew install openjdk@11 openjdk@8
	sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
	OSEXPORTS=~/.shell/os_exports.sh
	echo 'export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"' >> ${OSEXPORTS}
	echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"' >> ${OSEXPORTS}

	curl -s "https://get.sdkman.io" | bash
	source "$HOME/.sdkman/bin/sdkman-init.sh"
	sdk install java
	brew install maven
	brew install gradle

}

dev_tools() {

	printf "${magenta}" "\n Install DevTools from Cask"

	homebrew_update

	#Install DevTools
	brew install --cask postman
	brew install --cask jmeter
	brew install --cask vlc
	brew install --cask kap
	brew install --cask rectangle
	brew install --cask ngrok
	brew install --cask microsoft-edge
	brew install --cask slack
	brew install --cask ctop
	brew install --cask jetbrains-toolbox
	brew install --cask keycastr

	printf "${green}" "\n DevTools Installed"

}

node_install() {

	printf "${magenta}" "\n Install Node"

	homebrew_update
	# Language
	## Node / Javascript
	mkdir ~/.nvm
	brew install nvm                                                                                     # choose your version of npm
	nvm install node                                                                                     # "node" is an alias for the latest version
	brew install yarn

	printf "${green}" "\n DevTools Installed"

}

read -r -d '' GOLANG<<EOF
# Go development
export GOPATH="\${HOME}/.go"
export GOROOT="\$(brew --prefix golang)/libexec"
export PATH="\$PATH:\${GOPATH}/bin:\${GOROOT}/bin"
EOF

golang_install() {

	printf "${magenta}" "\n Install Golang"

	homebrew_update
  echo "${GOLANG}" > "${HOME}/.zshrc"

	brew install go

	printf "${green}" "\n Completed Golang"

}

database_install() {

	printf "${magenta}" "\n Install Golang"

	homebrew_update

	brew install --cask dbeaver-community # db viewer
	brew install libpq                  # postgre command line
	brew link --force libpq
	echo 'export PATH="/usr/local/opt/libpq/bin:$PATH"' >> ~/.shell/os_export

	printf "${green}" "\n Completed Database Tools"

}

docker_install() {

	printf "${magenta}" "\n Install Docker"

	homebrew_update

	brew install --cask docker
	brew install bash-completion
	brew install docker-completion
	brew install docker-compose-completion
	brew install docker-machine-completion

	printf "${green}" "\n Completed Docker"

}

parallels_install() {

	printf "${magenta}" "\n Installing Parallel"

	homebrew_update

	brew install --cask parallels

	printf "${green}" "\n Completed Parallel"

}

template() {

	printf "${magenta}" "\n Installing"

	homebrew_update

	printf "${green}" "\n Completed"

}

while [[ "${#}" -gt 0 ]]; do
	case "${1}" in
		help)
			print_version
			usage
			exit 0
			;;
		version)
			print_version
			exit 0
			;;
		xcode)
			xcode_install
			exit 0
			;;
		basic)
			basic_packages_install
			exit 0
			;;
		git)
			git_install
			exit 0
			;;
		gitconfig)
			git_config
			exit 0
			;;
		bash)
			bash_install
			exit 0
			;;
		bashconfig)
			bash_config
			exit 0
			;;
		zsh)
			zsh_install
			exit 0
			;;
		tmux)
			tmux_install
			exit 0
			;;
		python)
			python_install
			exit 0
			;;
		pydatascience)
			pydatascience
			exit 0
			;;
		pyaws)
			pyaws
			exit 0
			;;
		vscode)
			vscode_install
			exit 0
			;;
		vim)
			vim_install
			exit 0
			;;
		iterm2)
			term2_install
			exit 0
			;;
		docker)
			docker_install
			exit 0
			;;
		kubernetes)
			kubernetes_install
			exit 0
			;;
		aws)
			aws_install
			exit 0
			;;
		terraform)
			terraform_install
			exit 0
			;;
		java)
			java_install
			exit 0
			;;
		devtools)
			dev_tools
			exit 0
			;;
		node)
			node_install
			exit 0
			;;
		golang)
			node_install
			exit 0
			;;
		database)
			database_install
			exit 0
			;;
		docker)
			docker_install
			exit 0
			;;
		parallels)
			parallels_install
			exit 0
			;;
		--|-*|*)
			usage_fatal "${1}"
			exit 1
			;;
	esac
done
