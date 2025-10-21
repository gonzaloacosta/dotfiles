# =====================================================================
# 🧭 Start ZSH Time
# =====================================================================
#zmodload zsh/zprof

# =====================================================================
# 🧭 PATH & ENVIRONMENT
# =====================================================================
export HOME_BREW="/opt/homebrew"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
export PATH="$HOME/.bash-my-aws/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

export LANG="en_US.UTF-8"
export EDITOR="/opt/homebrew/bin/nvim"
export PAGER="/usr/bin/less -isXF"
export MANPAGER="/usr/bin/less -isXF"

# =====================================================================
# ☕ LANGUAGE & SDK SETTINGS
# =====================================================================
# Java
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"

# Python / Pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#eval "$(pyenv init -)"

# Java / Jenv
eval "$(jenv init -)"

# Go
export GOPATH="$HOME/go"

# # Node / NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Ansible
export ANSIBLE_NOCOWS=1
export ANSIBLE_PYTHON_INTERPRETER=auto_silent
export ANSIBLE_DEPRECATION_WARNINGS=false

# SSH Defaults
export SSH_KEY="$HOME/.ssh/gonzalo.acosta"
export SSH_USER="gonzalo.acosta"

# Nix
export NIX_CONF_DIR="$HOME/.config/nix"
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# =====================================================================
# 🧩 SHELL BEHAVIOR & HISTORY
# =====================================================================
setopt prompt_subst
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt interactive_comments
unsetopt PROMPT_SP
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=200000
SAVEHIST=200000


# =====================================================================
# 🐍 CUSTOM FUNCTIONS
# =====================================================================
function ranger {
  local IFS=$'\t\n'
  local tempfile="$(mktemp -t tmp.XXXXXX)"
  local ranger_cmd=(
    command
    ranger
    --cmd="map Q chain shell echo %d > \"$tempfile\"; quitall"
  )
  ${ranger_cmd[@]} "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(pwd)" ]]; then
    cd -- "$(cat "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}
alias rr='ranger'

# Directory navigation helpers
cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { find . -type f -not -path '*/.*' | fzf | pbcopy; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# =====================================================================
# 🧱 ALIASES
# =====================================================================

# Common tools
alias rzsh='source ~/.zshrc'
alias vzsh='nvim ~/.zshrc'
alias vtmux='nvim ~/.config/tmux'
alias ls='lsd -a --group-directories-first'
alias ll='lsd -alh --group-directories-first'
alias la='tree'
alias cat='bat'
alias cl='clear'

# Git
alias g='git'
alias gs='git status'
alias gfp='git fetch --prune --force; git pull --ff'
alias gbc='git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dot='cd ~/dotfiles'
alias v='nvim'
alias v.='nvim .'
alias v..='nvim ..'
alias v...='nvim ../..'
alias v....='nvim ../../..'

# Terraform
alias tf='terraform'
alias tfsw="tfswitch -b $(brew --prefix)/terraform"
alias d='docker'
alias dc='docker-compose'

# Kubernetes
export KUBECONFIG="$HOME/.kube/config"
alias k9='k9s'
alias wa='watch -n 5'
alias kgr='kubectl get deployment -o custom-columns=DEPLOYMENT:.metadata.name,REPLICAS:.status.replicas,READY_REPLICAS:.status.readyReplicas,NODE_SELECTOR:.spec.template.spec.nodeSelector --sort-by=.metadata.name'
k8s-nodes() {
  local context="${1:-$(kubectl config current-context)}"

  echo "Nodes in context: $context"
  echo ""

  kubectl --context="$context" get nodes -o json | jq -r '
    ["NAME", "INSTANCE_ID", "TYPE", "ROLE", "INTERNAL_IP"],
    (.items[] |
      [
        .metadata.name,
        (.spec.providerID | split("/")[-1] // "N/A"),
        (.metadata.labels."node.kubernetes.io/instance-type" // "N/A"),
        (
          if .metadata.labels."node-role.kubernetes.io/master" then "master"
          elif .metadata.labels."node-role.kubernetes.io/control-plane" then "control-plane"
          else "worker"
          end
        ),
        ((.status.addresses[] | select(.type=="InternalIP") | .address) // "N/A")
      ]
    ) | @tsv
  ' | column -t
}


# Helm & Kustomize
alias h='helm'
alias kbu='kustomize build . | bat -l yaml -p'

# Security Tools
alias gobust='gobuster dir --wordlist ~/security/wordlists/diccnoext.txt --wildcard --url'
alias dirsearch='python dirsearch.py -w db/dicc.txt -b -u'
alias massdns='~/hacking/tools/massdns/bin/massdns -r ~/hacking/tools/massdns/lists/resolvers.txt -t A -o S bf-targets.txt -w livehosts.txt -s 4000'
alias server='python -m http.server 4445'
alias tunnel='ngrok http 4445'
alias fuzz='ffuf -w ~/hacking/SecLists/content_discovery_all.txt -mc all -u'

# Tmux
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tx='tmux'
alias tn='tmux new -s'

# FZF + Vim
alias ffv='nvim $(fzf)'
alias v='vim'
alias nv='nvim'
alias vim='nvim'

# Others
alias nm='nmap -sC -sV -oN nmap'
alias mat='tmux neww "cmatrix"'

# Build38
alias bd='export AWS_PROFILE=build38-development ; saml2aws login --idp-account=$AWS_PROFILE --username=$JUMPCLOUD_USERNAME ; export AWS_REGION=eu-north-1 ; echo $AWS_PROFILE $AWS_REGION'
alias bp='export AWS_PROFILE=build38-production ; saml2aws login --idp-account=$AWS_PROFILE --username=$JUMPCLOUD_USERNAME ; export AWS_REGION=eu-north-1 ; echo $AWS_PROFILE $AWS_REGION'
alias hsmips="aws cloudhsmv2 describe-clusters --query 'Clusters[*].{HsmIps:Hsms[*].EniIp,HsmNames:Hsms[*].HsmId}' --output json"
alias ins='instances'
alias img='images'
alias genpass='echo "$(date): $(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9')" | tee -a ~/rand_pass'
alias bdir='cd /Users/gonzalo.acosta/bitbucket/build38'

# Claude
alias cld='claude'
alias cldsp='claude --dangerously-skip-permissions'

# Not print aws prompt
SHOW_AWS_PROMPT=false

# Secrets
source ~/.env
alias rzsh='source ~/.zshrc'

# Build38 Jmeter
jmtops() { cd ~/bitbucket/build38/server/tak-performance-test-devops/src/main/resources/private/jmeter ; /Users/gonzalo.acosta/.local/share/apache-jmeter-5.5/bin/jmeter -t TAK.jmx & }
jmt() { cd ~/bitbucket/build38/server/tak-performance-test-backend/src/main/resources/private/jmeter ; $HOME/.local/share/apache-jmeter-5.5/bin/jmeter -t TAK.jmx & }

# Certs
alias certl='openssl x509 -noout -text -in '
certlb() { openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -noout }
certlbt() { openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -noout -text | less }
certlbt() { openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -noout -text }
deldsstore() { find . -name '.DS_Store' -type f -delete }
genkeyrsa() { openssl genrsa -out ${1}_rsa.pem 2048 ; openssl rsa -in ${1}_rsa.pem -outform PEM -pubout -out ${1}_rsa.pub }
genkeyec() { openssl ecparam -name prime256v1 -genkey -noout -out ${1}_ec.pem; openssl ec -in ${1}_ec.pem -pubout -out ${1}_ec.pem }
getsshkey() { ssh-keygen -q -t rsa -N '' -f $1 <<<y >/dev/null 2>&1 }
showcerts() { openssl s_client -showcerts -servername $1 -connect $1:$2 </dev/null }

# Check port without tools
checkport() { (echo >/dev/tcp/$1/$2) >/dev/null 2>&1 && echo "It's up" || echo "It's down" }

kubectl-events() {
	{
		echo $'TIME\tNAMESPACE\tTYPE\tREASON\tOBJECT\tSOURCE\tMESSAGE'
		kubectl get events -o json "$@" |
			jq -r '.items | map(. + {t: (.eventTime//.lastTimestamp)}) | sort_by(.t)[] | [.t, .metadata.namespace, .type, .reason, .involvedObject.kind + "/" + .involvedObject.name, .source.component + "," + (.source.host//"-"), .message] | @tsv'
	} |
		column -s $'\t' -t |
		less -S
}
delevicted() { for i in $(k get pods -o wide | grep Evicted | awk '{print $1}'); do k delete pod -n runners $i --grace-period 0; done }

diffdir() {
	case $1 in
	'list')
		title="🔦 Diff between dirs $2 and $3"
		echo $title
		echo " $(repeat_char "=" ${#title})"
		for i in $(find $2 -type f | grep -v .git); do echo "👉 diff $i ${3}$(echo $i | sed 's/^\.//g')"; done
		;;

	'show')
		title="🔦 Diff between dirs $2 and $3"
		echo $title
		echo " $(repeat_char "=" ${#title})"
		for i in $(find $2 -type f | grep -v .git); do
			echo "👉 $i"
			diff $i ${3}$(echo $i | sed 's/^\.//g')
		done
		;;
	esac
}

decode64() {
  base64 -d "$@" | cat
  echo
}

# =====================================================================
# 💡 PLUGINS & ENHANCEMENTS
# =====================================================================
# FZF configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load fzf key bindings
if [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
  source /usr/share/fzf/key-bindings.zsh
fi

# History search (Ctrl+R)
export FZF_CTRL_R_OPTS='
  --reverse
  --preview "echo {}"
  --preview-window=up,3,hidden
  --bind "?:toggle-preview"
'
bindkey '^R' fzf-history-widget

setopt interactive_comments

# =====================================================================
# ⚙️ COMPLETIONS
# =====================================================================
if [[ -o interactive ]]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}"
  autoload -Uz compinit
  compinit -d "$ZSH_COMPDUMP" -C
fi

# Kubernetes completion
alias k=kubectl
alias kns=kubens
alias kx=kubectx

# Bash-my-AWS
source ~/.bash-my-aws/aliases
source ~/.bash-my-aws/bash_completion.sh
#
# # AWS CLI completion
# complete -C "$(brew --prefix)/bin/aws_completer)" aws
#
# # SAML2AWS
# eval "$(saml2aws --completion-script-zsh)"

# Completion matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# =====================================================================
# 💾 OH MY ZSH 
# =====================================================================
export ZSH="$HOME/.oh-my-zsh"

plugins=(
  k9s
  git
  terraform
  uv
  kubectl
  kubectx
  helm
  aws
)

source $ZSH/oh-my-zsh.sh

# if [ -f "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]; then
#   source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# fi
# =====================================================================
# 💾 STARSHIP PROMPT
# =====================================================================
if command -v starship &>/dev/null; then
  type starship_zle-keymap-select >/dev/null ||
    {
      export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
      eval "$(starship init zsh)" >/dev/null 2>&1
    }
fi

# Prevent Zsh from printing an extra newline
export PROMPT_EOL_MARK=""
export PROMPT_SP=0

# =====================================================================
# Open man pages in neovim, if neovim is installed
# =====================================================================
if command -v nvim &>/dev/null; then
  export MANPAGER='nvim +Man!'
  export MANWIDTH=999
fi

# disable auto-update when running 'brew something'
export HOMEBREW_NO_AUTO_UPDATE="1"

# =====================================================================
# Ls with steroids
# =====================================================================
if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -lhg'
  alias lla='eza -alhg'
  alias tree='eza --tree'
fi

# =====================================================================
# Cat for gen-z
# =====================================================================
if command -v bat &>/dev/null; then
  # --style=plain - removes line numbers and git modifications
  # --paging=never - doesnt pipe it through less
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  # alias cata='bat --show-all --paging=never'
  alias cata='bat --show-all --paging=never --style=plain'
fi

setopt PROMPT_CR   # return to column 1 if no newline
setopt PROMPT_SP   # add a newline if cursor isn't at column 1

# =====================================================================
# VIM Mode
# =====================================================================
set -o vi
# =====================================================================
# 🧭 End ZSH Time
# =====================================================================
#zprof
