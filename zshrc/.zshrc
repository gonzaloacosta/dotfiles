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
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

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
export ANSIBLE_BECOME_PASSWORD="ZarateCity01!"

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
alias la='tree'
alias cat='bat'
alias cl='clear'
alias dot='cd ~/dotfiles'

# Git
alias g='git'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gp='git push origin HEAD'
alias gpu='git pull origin'
alias gl='git log --graph --color --oneline'
alias gs='git status'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gfp='git fetch --prune --force; git pull --ff'
alias gbc='git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'

# Docker
alias dco='docker compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias dx='docker exec -it'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfv='terraform validate'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfda='terraform destroy -auto-approve'

# Kubernetes
export KUBECONFIG="$HOME/.kube/config"
alias kg='kubectl get'
alias kd='kubectl describe'
alias ka='kubectl apply -f'
alias kl='kubectl logs -f'
alias kc='kubectx'
alias kns='kubens'
alias ke='kubectl exec -it'
alias wa='watch -n 5'
alias kgr='kubectl get deployment -o custom-columns=DEPLOYMENT:.metadata.name,REPLICAS:.status.replicas,READY_REPLICAS:.status.readyReplicas,NODE_SELECTOR:.spec.template.spec.nodeSelector --sort-by=.metadata.name'

# Helm & Kustomize
alias h='helm'
alias hi='helm install'
alias hu='helm upgrade'
alias hl='helm lint'
alias ht='helm template'
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

# Build38 Secrets
source ~/.env-build38

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
# =====================================================================
# ⚙️ COMPLETIONS
# =====================================================================
#fpath=(~/.zsh/completions $fpath)
source <(kubectl completion zsh)

# ⚡ Zsh completion system — optimized and secure

# Only apply shell-specific configuration if Solo aplica en shells interactivos (evita overhead en scripts)
[[ -o interactive ]] || return

# Define the location of the completion dump file 
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}"

# Load the completion system
autoload -Uz compinit

# If the cache exist and it have less 24h doesn't recompile
if [[ -n $ZSH_COMPDUMP(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP" -C
else
  compinit -d "$ZSH_COMPDUMP"
fi

# Compila el archivo dump para acelerar lecturas futuras
if [[ -f $ZSH_COMPDUMP && ! -f "${ZSH_COMPDUMP}.zwc" ]]; then
  zcompile "$ZSH_COMPDUMP"
fi


# Kubernetes completion
alias k=kubectl
alias kns=kubens
alias kx=kubectx
compdef __start_kubectl k
compdef __start_kubectl kns
compdef __start_kubectl kx

# Bash-my-AWS
source ~/.bash-my-aws/aliases
source ~/.bash-my-aws/bash_completion.sh

# AWS CLI completion
complete -C "$(brew --prefix)/bin/aws_completer)" aws

# SAML2AWS
eval "$(saml2aws --completion-script-zsh)"

# Completion matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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
# 💾 STARSHIP PROMPT
# =====================================================================
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

set -o vi 

# =====================================================================
# 🧭 End ZSH Time
# =====================================================================
#zprof
