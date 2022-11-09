# Functions:
export OAZSSH_VERSION="0.7.1"

# O'R:
function oazssh() {
    oazssh_usage() { 
        echo "Usage: oazssh [-v] [-e <env>] [-k keyfile] [-s srv || -S servername]" 1>&2; return
    }

    local OPTIND env_val key_val srv_val lport_val rport_val change_srv_name VERBOSE
    VERBOSE=0
    env_val=dev
    key_val=$HOME/.ssh/id_rsa
    srv_val=ap0
    server_name=
    change_srv_name=0
    while getopts "ve:k:s:S:l:r:" o; do
        case "${o}" in
            v)
                VERBOSE=1
                ;;
            e)
                env_val="${OPTARG}"
                ;;
            k)
                key_val="${OPTARG}"
                ;;
            s)
                srv_val="${OPTARG}"
                ;;
            S)
                server_name="${OPTARG}"
                change_srv_name=1
                ;;
            *)
                oazssh_usage
                return
                ;;
        esac
    done
    shift $((OPTIND-1))
    SUBSCRIPTION=$(az account show --query 'id' --output tsv | tr -d '[\r\n]')
    SUBSCRIPTIONNAME="SharedServices"
    BASTION=bas-cus-ss-infra-bastion-1
    BASTIONRG=rg-cus-ss-infra-network-1
    case ${env_val} in
        d*)
          VMRG=rg-cus-nprod-dev-stibo-app-1
          ev="d"
          ;;
        t*|u*)
          VMRG=rg-cus-nprod-test-stibo-app-1
          ev="t"
          ;;
        q*)
          VMRG=rg-cus-nprod-qa-stibo-app-1
          ev="q"
          ;;
        x*)
          VMRG=rg-cus-nprod-infra-platform-1
          ev="x"
          ;;
        pe*)
          VMRG=rg-cus-nprod-perf-stibo-app-1
          ev="r"
          ;;
        au*)
          VMRG=rg-cus-nprod-devops-stibo-app-1
          ev="a"
          ;;
        pr*)
          VMRG=rg-cus-prod-stibo-app-1
          ev="p"
          SUBSCRIPTION=$(az account show --name "Prod" --query "id" --output tsv | tr -d '[\r\n]')
          ;;
        ndr*)
          VMRG=rg-eus2-nprod-perf-stibo-app-1
          ev="f"
          SUBSCRIPTION=$(az account show --name "DR-Non-Prod" --query "id" --output tsv | tr -d '[\r\n]')
	  SUBSCRIPTIONNAME="DR-SharedServices"
	  BASTION=bas-eus2-ss-infra-bastion-1
	  BASTIONRG=rg-eus2-ss-infra-network-1
          ;;
    esac
    if (( ${change_srv_name} )) ; then
        :
        # echo "server_name supplied in args"
        # echo "server name is .${server_name}."
    elif [ ${ev} = "f" ] ; then
        server_name="az3${ev}lepcmepc${srv_val}"
        # echo "server name set to ${server_name}"
    else
        server_name="az1${ev}lepcmepc${srv_val}"
        # echo "server name set to ${server_name}"
    fi
    if (( ${VERBOSE} > 0 )); then
        set -x
    fi
    
    az network bastion ssh --name ${BASTION} \
        --resource-group ${BASTIONRG} \
        --subscription ${SUBSCRIPTIONNAME} \
        --target-resource-id /subscriptions/${SUBSCRIPTION}/resourceGroups/${VMRG}/providers/Microsoft.Compute/virtualMachines/${server_name} \
        --auth-type ssh-key \
        --username adminuser \
        --ssh-key ${key_val}
}

function oazssht() {
    oazssht_usage() { 
        echo "Usage: oazssht [-e <env>] [-k keyfile] [-s srv || -S servername][ -w | -l]" 1>&2; 
        echo "               [-v] [-l local_port] [-r remote_port]"
    }

    local OPTIND env_val key_val srv_val lport_val rport_val change_srv_name VERBOSE
    VERBOSE=0
    env_val=dev
    key_val=$HOME/.ssh/id_rsa
    srv_val=ap0
    lport_val=5555
    rport_val=22
    server_name=
    change_srv_name=0
    while getopts "ve:k:s:S:l:r:" o; do
        case "${o}" in
            v)
                VERBOSE=1
                ;;
            e)
                env_val="${OPTARG}"
                ;;
            k)
                key_val="${OPTARG}"
                ;;
            s)
                srv_val="${OPTARG}"
                ;;
            S)
                server_name="${OPTARG}"
                change_srv_name=1
                ;;
            r)
                rport_val="${OPTARG}"
                ;;
            l)
                lport_val="${OPTARG}"
                ;;
            *)
                oazssh_usage
                return
                ;;
        esac
    done
    shift $((OPTIND-1))
    SUBSCRIPTION=$(az account show --query 'id' --output tsv | tr -d '[\r\n]')
    SUBSCRIPTIONNAME="SharedServices"
    BASTION=bas-cus-ss-infra-bastion-1
    BASTIONRG=rg-cus-ss-infra-network-1
    case ${env_val} in
        d*)
            VMRG=rg-cus-nprod-dev-stibo-app-1
            ev="d"
            ;;
        t*|u*)
            VMRG=rg-cus-nprod-test-stibo-app-1
            ev="t"
            ;;
        q*)
            VMRG=rg-cus-nprod-qa-stibo-app-1
            ev="q"
            ;;
        x*)
          VMRG=rg-cus-nprod-infra-platform-1
          ev="x"
          ;;
        pe*)
 	      VMRG=rg-cus-nprod-perf-stibo-app-1
	      ev="r"
	      ;;
        au*)
          VMRG=rg-cus-nprod-devops-stibo-app-1
          ev="a"
          ;;
        pr*)
          VMRG=rg-cus-prod-stibo-app-1
          ev="p"
          SUBSCRIPTION=$(az account show --name "Prod" --query "id" --output tsv | tr -d '[\r\n]')
          ;;
        ndr*)
          VMRG=rg-eus2-nprod-perf-stibo-app-1
          ev="f"
          SUBSCRIPTION=$(az account show --name "DR-Non-Prod" --query "id" --output tsv | tr -d '[\r\n]')
	  SUBSCRIPTIONNAME="DR-SharedServices"
	  BASTION=bas-eus2-ss-infra-bastion-1
	  BASTIONRG=rg-eus2-ss-infra-network-1
          ;;
    esac
    if (( ${change_srv_name} )) ; then
        
        # echo "server_name supplied in args"
        # echo "server name is .${server_name}."
    elif [ ${ev} = "f"]  ; then
        server_name="az3${ev}lepcmepc${srv_val}"
        echo "server name set to ${server_name}"
    else
        server_name="az1${ev}lepcmepc${srv_val}"
        echo "server name set to ${server_name}"
    fi
    if (( ${VERBOSE} > 0 )); then
        set -x
    fi

    set -x
    az network bastion tunnel --name ${BASTION} \
        --resource-group ${BASTIONRG} \
        --subscription ${SUBSCRIPTIONNAME} \
        --target-resource-id /subscriptions/${SUBSCRIPTION}/resourceGroups/${VMRG}/providers/Microsoft.Compute/virtualMachines/${server_name} \
        --resource-port ${rport_val} \
        --port ${lport_val}
}

# Nex Azure:
function nazssh() {
   SUBSCRIPTION=$(az account show --query 'id' --output tsv)
   az network bastion ssh --name ${AZENV}-bastion \
       --resource-group ${AZENV}-rg \
       --target-resource-id /subscriptions/${SUBSCRIPTION}/resourceGroups/${AZENV}-rg/providers/Microsoft.Compute/virtualMachines/${AZENV}-$1 \
       --auth-type ssh-key \
       --username adminuser \
       --ssh-key ~/.ssh/id_rsa
}
function nazssht() {
   SUBSCRIPTION=$(az account show --query 'id' --output tsv)
   az network bastion tunnel --name ${AZENV}-bastion \
       --resource-group ${AZENV}-rg \
       --target-resource-id /subscriptions/${SUBSCRIPTION}/resourceGroups/${AZENV}-rg/providers/Microsoft.Compute/virtualMachines/${AZENV}-$1 \
       --resource-port 22 \
       --port 5555
}

