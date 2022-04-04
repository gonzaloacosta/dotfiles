# Var Export
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin:~/.local/bin:$HOME/.bash-my-aws/bin:$HOME/.local/bin/"
export LANG=en_US.UTF-8
export PAGER='/usr/bin/less -isXF'
export MANPAGER='/usr/bin/less -isXF'
export EDITOR=nvim


# Kubernetes
export do="-o yaml --dry-run=client"

# SSH Agent
export SSH_KEYS="$HOME/.ssh"

# saml2aws
eval "$(saml2aws --completion-script-zsh)"

# Build38
export BKEYS="$HOME/Documents/Build38/Keys"
export NEXUS_USERNAME=jenkins
export NEXUS_PASSWORD='"{78(^d72@/5B&Ig'


# Java
#export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_HOME=$(/usr/libexec/java_home -v11)
#export PATH="/usr/local/opt/openjdk@8/bin:$PATH"

# Ansible
export ANSIBLE_NOCOWS=1

export PROM_AMP_PROD='http://a2397789569c740239b005d0abe393c2-ad41c1b390bedc11.elb.us-east-1.amazonaws.com:9090/prometheus/'

source ~/.bash-my-aws/aliases

export build=~/repo/build38
export moodys=~/repo/moodys
