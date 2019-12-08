$cred = Get-Credential

$rg = New-AzResourceGroup rg01 -Location 'Korea Central'
$vm = New-AzVM -ResourceGroupName rg01 -Name vm01 -Image UbuntuLTS -Credential $cred

<# Run these commands in the Run Command section of the 
 # Azure portal for your Ubuntu VM
 # Shell commands run in the Azure console
 $ sudo apt update
 $ sudo apt install apache2 -y
 $ sudo ufw app list
 $ sudo ufw allow 'Apache'
 $ sudo ufw status
 $ sudo systemctl status apache2
#>

$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName rg01 -Name vm01

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

$nsg | Set-AzNetworkSecurityGroup

$ip = Get-AzPublicIpAddress -Name vm01
$addr = $ip.IpAddress

start microsoft-edge:"http://$addr"

Remove-AzResourceGroup -Name rg01 -Force


