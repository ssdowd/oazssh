# Functions:
# O'R:
function oazssh() {
    ev=$1
    srv=$2
    key=${3:-~/.ssh/id_rsa}
    case ${ev} in
        d*)
          VMRG=rg-cus-nprod-dev-stibo-app-1
          ev=d
          ;;
        t*)
          VMRG=rg-cus-nprod-test-stibo-app-1
          ev=t
          ;;
        perf)
    esac
  BASTION=bas-cus-ss-infra-bastion-1
  BASTIONRG=rg-cus-ss-infra-network-1
  SUBSCRIPTION=$(az account show | jq -r '.id')
  az network bastion ssh --name ${BASTION} \
      --resource-group ${BASTIONRG} \
      --subscription "SharedServices" \
      --target-resource-id /subscriptions/${SUBSCRIPTION}/resourceGroups/${VMRG}/providers/Microsoft.Compute/virtualMachines/az1${ev}lepcmepc${srv} \
      --auth-type ssh-key \
      --username adminuser \
      --ssh-key ${key}
}

function oazssht() {
    ev=$1
    srv=$2
    case ${ev} in
        d*)
          VMRG=rg-cus-nprod-dev-stibo-app-1
          ev=d
          ;;
        t*)
          VMRG=rg-cus-nprod-test-stibo-app-1
          ev=t
          ;;
        perf)
    esac
  BASTION=bas-cus-ss-infra-bastion-1
  BASTIONRG=rg-cus-ss-infra-network-1
  SUBSCRIPTION=$(az account show | jq -r '.id')
  set -x
  az network bastion tunnel --name ${BASTION} \
      --resource-group ${BASTIONRG} \
      --subscription "SharedServices" \
      --target-resource-id /subscriptions/${SUBSCRIPTION}/resourceGroups/${VMRG}/providers/Microsoft.Compute/virtualMachines/az1${ev}lepcmepc${srv} \
      --resource-port 22 \
      --port 5555
}

# Nex Azure:
function nazssh() {
    echo hello
   az network bastion ssh --name ${AZENV}-bastion \
       --resource-group ${AZENV}-rg \
       --target-resource-id /subscriptions/896d2235-478d-430b-9c29-3b413342962e/resourceGroups/${AZENV}-rg/providers/Microsoft.Compute/virtualMachines/${AZENV}-$1 \
       --auth-type ssh-key \
       --username adminuser \
       --ssh-key ~/.ssh/id_rsa
}
function nazssht() {
   az network bastion tunnel --name ${AZENV}-bastion \
       --resource-group ${AZENV}-rg \
       --target-resource-id /subscriptions/896d2235-478d-430b-9c29-3b413342962e/resourceGroups/${AZENV}-rg/providers/Microsoft.Compute/virtualMachines/${AZENV}-$1 \
       --resource-port 22 \
       --port 5555
}

