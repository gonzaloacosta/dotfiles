# Git full diff
full-diff() {

    echo "---------------------------"
    echo "-- Diff Unstaged <> HEAD --"
    echo "---------------------------"

    for next in $( git ls-files --others --exclude-standard ); do
        git --no-pager diff --no-index /dev/null "$next"
    done

    echo "---------------------------"
    echo "--- Diff Staged <> HEAD ---"
    echo "---------------------------"

    git --no-pager diff HEAD
}

kps1() {

    source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
    export KUBE_PS1_SYMBOL_ENABLE=false
    export PS1='$(kube_ps1)'$PS1

}

getip() {

    instance-ip $(instances | grep $1 | awk '{print $1}') | awk '{print $3}'

}

trdshost() {

    aws rds describe-db-instances \
        --db-instance-identifier $1 \
        --region $2 \
        --query 'DBInstances[*].Endpoint.Address' | jq -r '.[0]'

}

ec2env() {

    aws ec2 describe-instances \
        --query "Reservations[*].Instances[*].{VpcId:VpcId,InstanceId:InstanceId,PrivateIP:PrivateIpAddress,PublicIP:PublicIpAddress,LaunchTime:LaunchTime,Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
        --filters "Name=instance-state-name,Values=running" \
        --output table \
        --region $1 \
        --filters "Name=tag:$2,Values=$3"

}

ec2info() {

    aws ec2 describe-instances \
        --query "Reservations[*].Instances[*].{VpcId:VpcId,InstanceId:InstanceId,PrivateIP:PrivateIpAddress,PublicIP:PublicIpAddress,LaunchTime:LaunchTime,Type:InstanceType,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
        --filters "Name=instance-state-name,Values=running" \
        --output table \
        --region $1

}

devrelease() {

    make git/commit-and-push/all BRANCH=dev MESSAGE="$1" && make up BRANCH=dev ;

}

# does both dev and staging
stagingrelease() {

    make git/commit-and-push/all BRANCH=dev MESSAGE="$1" && \
    make up BRANCH=dev && \
    make git/branch/checkout BRANCH=staging && \
    make up BRANCH=staging && \
    make git/branch/merge BRANCH=dev && \
    make git/commit-and-push/all BRANCH=staging MESSAGE="merged with dev" && \
    make up BRANCH=staging ;

}

checkout() {

    make git/branch/checkout BRANCH=$1 && make up BRANCH=$1 ;

}

runtest() {

    python -m maa.testing.run --disable-warning --env $1 -v --tb=line ;

}

gitfp() {

    git fetch --prune && \
    git pull

}

yaml() {

    python3 ~/scripts/pparse.py "$1"

}

bssh() {

    ssh gonzalo.acosta@$(getip $1)

}

gitsetconf() {

  git config user.name "$1"
  git config user.email "$2"

}

gitgetconf() {

  git config -l | egrep "user.name|user.email"

}

gituserusage() {

    echo ""
    echo "ERROR: incorrect script invocation."
    echo ""
    echo "Usage:"
    echo "  $(basename $0) [ <b38 | semper | gmail | moodys> ] "
    echo ""
    exit 1
}


gitctx() {

    user_name='Gonzalo Acosta'

    case $1 in

        "gmail")
            gitsetconf $user_name gonzaloacostapeiro@gmail.com
            gitgetconf
            ;;

        "show")
            gitgetconf
            ;;

        "help")
            gituserusage
            ;;

        *)
            gituserusage
            ;;

    esac

}

certl() {
    
    openssl x509 -noout -text -in $1

}

certlb() {

    openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -noout ;

}
certlbt() {

    openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -noout -text | less;

}

name_to_lower_case() {

    for i in $(ls) ; do echo "mv $i $(echo $i | tr '[A-Z]' '[a-z]')" ; done

}

promctl() {

	case $1 in

		"dev")
			promql --host $PROM_DEV
			;;

		"prod")
			promql --host $PROM_PROD
			;;

		*)
			;;
	esac

}

kpodimages() {

	#kubectl get pods $1 -o jsonpath='{.items[*].spec.containers[?(@.name=="nginx")].image}'
	kubectl get pods $1 -o jsonpath='{.items[*].spec.containers[*].image}'

}

genkeyrsa() {

    openssl genrsa -out ${1}_rsa.pem 2048
    openssl rsa -in ${1}_rsa.pem -outform PEM -pubout -out ${1}_rsa.pub

}

genkeyec() {

	openssl ecparam -name prime256v1 -genkey -noout -out ${1}_ec.pem
	openssl ec -in ${1}_ec.pem -pubout -out ${1}_ec.pem

}

getsshkey() {

	ssh-keygen -q -t rsa -N '' -f $1 <<<y >/dev/null 2>&1

}

delevicted() {

    for i in $(k get pods -o wide | grep Evicted | awk '{print $1}') ; do k delete pod -n runners $i --grace-period 0 ; done

}
