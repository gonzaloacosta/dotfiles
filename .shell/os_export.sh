# Export
export PATH="$PATH:~/.local/bin:$HOME/.bash-my-aws/bin:$HOME/.local/bin/"
export LANG=en_US.UTF-8
export PAGER='/usr/bin/less -isXF'
export MANPAGER='/usr/bin/less -isXF'
export EDITOR=nvim
export codo=~/code

# Kubernetes
export do="-o yaml --dry-run=client"

# SSH Agent
export SSH_KEYS="$HOME/.ssh"

# saml2aws
eval "$(saml2aws --completion-script-zsh)"

# Java
#export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_HOME=$(/usr/libexec/java_home -v11)
#export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

# Ansible
export ANSIBLE_NOCOWS=1

export codo=~/code

source ~/.bash-my-aws/aliases