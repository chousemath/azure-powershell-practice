<#
# At startup, PowerShell loads only the core cmdlets by default. 
# This means the cmdlets you need to work with Azure won't be loaded. 
# The most reliable way to load the cmdlets you need is to import them manually at the start of your PowerShell session.
Import-Module Az
# You also need to authenticate before you can execute Az commands
Connect-AzAccount
#>

<#
# Determine which Az subscription is active
Get-AzContext
# Get a list of all your subscriptions
Get-AzSubscription
#>


<#
# List the names of all your resource groups
Get-AzResourceGroup | ForEach-Object {$_.ResourceGroupName}
#>

<#
# Destroy a single resource group
Remove-AzResourceGroup -Name AzTest
# This takes a bit of time (pshell waits)
#>

<#
# Create a new resource group
New-AzResourceGroup -Name AzTest -Location 'Korea Central'
# To create the resource groups, the Azure portal is a reasonable choice. 
# These are one-off tasks, so you don't need scripts to do them.
#>

<#
# Creating a new virtual machine instance in Azure
New-AzVM `
    -ResourceGroupName AzTest `
    -Name AzTestVM `
    -Image UbuntuLTS
# You will be asked to supply your email and password
# Creation of the VM takes a bit of time
#>

<#
# Make sure that the virtual machine has been created
Get-AzVM
#>

<#
# Removing a virtual machine instance in Azure
Remove-AzVM `
    -Name AzTestVM `
    -ResourceGroupName AzTest
# You will be prompted for confirmation
# This process also takes some time (pshell waits until finished)
#>

<#
# Check to make sure the virtual machine is gone
Get-AzVM
#>

<#
# Use a loop to create a coup VMs
$resourceGroupName = "AzTest"
$imageName = "UbuntuLTS"
$c = Get-Credential
For ($i = 0; $i -lt 3; $i++) {
    $vmName = "test-vm-$i"
    New-AzVM `
        -Name $vmName `
        -ResourceGroupName $resourceGroupName `
        -Image $imageName `
        -Credential $c
}
# AZ asks you for your credentials every time
#>
