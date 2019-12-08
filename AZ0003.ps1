$cred = Get-Credential

# create a new resource group to contain everything for this project
$rg = New-AzResourceGroup rg01 -Location 'Korea Central'

# create a new vm to host your demo website
$vm = New-AzVM -ResourceGroupName rg01 -Name vm01 -Image UbuntuLTS -Credential $cred

<# Run these commands in the Run Command section of the 
 # Azure portal for your Ubuntu VM to install a simple
 # web server

 $ sudo apt update
 $ sudo apt install apache2 -y
 $ sudo ufw app list
 $ sudo ufw allow 'Apache'
 $ sudo ufw status
 $ sudo systemctl status apache2
#>

# Your network security group controls what comes in and goes out
$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName rg01 -Name vm01

# Allow free traffic on port 80 (HTTP)
$nsg | Add-AzNetworkSecurityRuleConfig `
    -Name OpenHttp `
    -Description "Allow http traffic" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix "Internet" `
    -SourcePortRange * `
    -DestinationPortRange 80 `
    -DestinationAddressPrefix *

# Actually execute your changes to the security group (I think...)
$nsg | Set-AzNetworkSecurityGroup

# Get the public ip address of your vm
$ip = Get-AzPublicIpAddress -Name vm01
$addr = $ip.IpAddress

# Open up your website in a new Edge window
start microsoft-edge:"http://$addr"

# Clean everything up!
Remove-AzResourceGroup -Name rg01 -Force


