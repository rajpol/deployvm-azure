read -p "Please enter the resource group name: " RG
read -p "Please enter the resource group region: " RG_REGION
echo " Creating resourse group with name ${RG} "
az group create --location $RG_REGION -n ${RG}
echo "Creating virtual network in resource group ${RG}"
az network vnet create -g ${RG} -n ${RG}-prod-vNet1 --address-prefix 10.1.0.0/16 -l ${RG_REGION}
echo "Creating subnets"
az network vnet subnet create -g ${RG} --vnet-name ${RG}-prod-vNet1 -n ${RG}-prod-sn1 --address-prefix 10.1.1.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-prod-vNet1 -n ${RG}-prod-sn2 --address-prefix 10.1.2.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-prod-vNet1 -n ${RG}-prod-sn3 --address-prefix 10.1.3.0/24
echo "Creating NSG"
az network nsg create -g ${RG} -n ${RG}-NSG1 -l ${RG_REGION}
az network nsg rule create -g ${RG} --nsg-name ${RG}-NSG1 -n ${RG}-NSG1-rule1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges '*' \
--access Allow --protocol Tcp --description "Allow All traffic"
echo "creating vm"
az vm create -g ${RG} --name ${RG}-Testvm1 --image UbuntuLTS --vnet-name ${RG}-prod-vNet1 \
--subnet ${RG}-prod-sn1 --admin-username rajpol --admin-password "iam@1234@1234" --size Standard_B1s --nsg ${RG}-NSG1 
