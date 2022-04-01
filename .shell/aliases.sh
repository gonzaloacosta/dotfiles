# Reload
alias rzsh='source ~/.zshrc'
alias ezsh='vim ~/.zshrc'
alias eshell='vim ~/.shell/'
alias rshell='source ~/.shell/*.sh'

alias gchange='vim ~/.gitconfig'

alias shtop='htop'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias less='less -R'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias weather='curl v2.wttr.in'

# Dotfiles
alias dotfiles='git --git-dir=$HOME/$DOTFILES --work-tree=$HOME'
alias dfu='dotfiles pull -q && dotfiles submodule update -q --init --recursive && exec $(which zsh)'
alias dfsubup='dotfiles submodule update --init --remote && dotfiles submodule foreach --recursive git submodule update --init'
alias cf='dotfiles'
alias cfu='dfu'
alias cfsubup='dfsubup'

# Docker
alias dc='docker-compose'
alias dk='docker'
alias dps='docker ps -a'
alias dex='docker exec -it'
alias dra='docker ps -a  -q | xargs docker rm -f'

# Misc
alias fu='sudo $(fc -ln -1)'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias myip='curl -s ifconfig.me'
alias type='type -f'

# Basic
alias rm='rm -i'
#alias cp='cp -i'
alias mv='mv -i'
alias ls='lsd'
alias ll='lsd -lF'
alias la='lsd -aF'
alias ll='lsd -ltr'
alias la='lsd -aF'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vt='vim -c "NERDTree" $1'
alias cat='bat'
alias rm=trash


# Openshift
alias ge="oc get events --sort-by='{.lastTimestamp}'"
alias gp="oc get pods"
alias gpwi="oc get pods -o wide"
alias gpw="oc get pods -w"
alias gn="oc get nodes"
alias gr="oc get route"
alias gnw="oc get nodes -o wide"
alias dp="oc delete pod"
alias owi="oc whoami -c"
alias owis="oc whoami --show-server"
alias og='oc get'
alias od='oc delete'
alias oe='oc edit'
alias ocpsem='oc login -u admin https://api.ocp4.labs.semperti.local:6443'

# Tmux
alias tmux="TERM=xterm-256color tmux"

# Kubernetes
alias k=kubectl
alias k0='sudo k0s'
alias kdp='kubectl delete pod --force --grace-period=0'
alias kr='kubectl run'
alias kg='kubectl get'
alias kedit='kubectl edit'
alias kdr='kubectl get deployment -o custom-columns=DEPLOYMENT:.metadata.name,REPLICAS:.status.replicas,READY_REPLICAS:.status.readyReplicas,NODE_SELECTOR:.spec.template.spec.nodeSelector --sort-by=.metadata.name'
alias kdi='kubectl get deployment -o custom-columns=DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[].image,READY_REPLICAS:.status.readyReplicas,NODE_SELECTOR:.spec.template.spec.nodeSelector --sort-by=.metadata.name'
alias klos='kubectl logs -f'
alias klogs='kubectl logs'
alias kex='kubectl exec -it'
alias kexi='kubectl exec -it'
alias kdep='kubectl describe pod'
alias kcrash='k get pods | egrep -v "Running|Completed"'

# kubectl
alias k=kubectl
complete -F _complete_alias k

# kubectx
alias kx=kubectx
complete -F _complete_alias kx

# kubens
alias kns=kubens
complete -F _complete_alias kn


# Vagrant
alias va='vagrant'
alias vassh='vagrant ssh'

# Terraform
alias tf=terraform
alias tfi='terraform init'
alias tfv='terraform validate'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfda='terraform destroy -auto-approve'

# Build
alias btunup='ssh -i ~/Documents/Build38/Keys/ec2_tunnel.pem ec2-user@ec2-34-249-206-204.eu-west-1.compute.amazonaws.com -ND 8157 &'
alias btun='ssh -i ~/Documents/Build38/Keys/ec2_tunnel.pem ec2-user@ec2-34-249-206-204.eu-west-1.compute.amazonaws.com'
alias bld='saml2aws login --idp-account=build38-development --disable-keychain'
alias blp='saml2aws login --idp-account=build38-production --disable-keychain'
alias bed='export AWS_PROFILE=build38-development'
alias bep='export AWS_PROFILE=build38-production'
alias sshga='ssh -l gonzalo.acosta'

alias docs='cd ~/Documents'
alias repos='cd ~/repos'
alias build='cd ~/repos/build38'
alias moodys='cd ~/repos/moodys'
alias benvs='cd ~/repos/build38/envs'

# Misc
alias zshreload='source ~/.zshrc'         # reload ZSH
alias zchange='code ~/.zshrc'             # reload ZSH
alias gchange='code ~/.gitconfig'         # reload ZSH

alias shtop='sudo htop'                   # run `htop` with root rights
alias grep='grep --color=auto'            # colorize `grep` output
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
#alias less='less -R'

alias rm='rm -i'                          # confirm removal
alias cp='cp -i'                          # confirm copy
alias mv='mv -i'                          # confirm move
alias cal='gcal --starting-day=1'         # print simple calendar for current month
alias weather='curl v2.wttr.in'           # print weather for current location (https://github.com/chubin/wttr.in)

# Git
alias gitlog='git log --all --oneline --decorate --graph'
alias onflict='git diff --name-only --diff-filter=U'
alias gitcm='git checkout master'
alias gitcd='git checkout develop'
alias gitcb='git checkout'
#alias gituser='~/Scripts/gituser'
#alias openrepo="open $(git remote -v | grep push | awk '{print $2}')"

# RH Bastion
alias sshrh='ssh gonzalo.acosta-semperti.com@bastion.7303.sandbox198.opentlc.com'

# Sort Network Subnets
alias sortnet='sort -t . -k 3,3n -k 4,4n'

# AWS
alias ec2i='~/Scripts/aws/ec2-info.py'
alias getsts='aws sts get-caller-identity --query Arn --profile $1'

# Curl
# https://stackoverflow.com/questions/18215389/how-do-i-measure-request-and-response-times-at-once-using-curl
alias curltime="curl -w \"@$HOME/.curl-format.txt\" -o /dev/null -s "

# Fuzzy Finder
alias ffp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias ff='fzf'

# Kubernetes
#alias kubeon="~/Scritps/kube-ps1.sh on"
#alias kubeoff="~/Scritps/kube-ps1.sh off"

# Tmux
alias tml='tmux list-sessions'
alias tma='tmux attach-session -t'

# Podman
alias docker='sudo docker'
alias podman='sudo podman'
alias pru='sudo podman run'
alias pb='sudo podman build'
alias prm='sudo podman rm'
alias prmi='sudo podman rmi'
alias pst='sudo podman stop'
alias pl='sudo podman ps -a'
alias pli='sudo podman imagesa'
alias certl='openssl x509 -noout -text -in '

# Kubernetes Lab
alias kubelab='cd ~/repos/tech/vagrant/k8s_ubuntu'

alias wa='watch -n 5'
