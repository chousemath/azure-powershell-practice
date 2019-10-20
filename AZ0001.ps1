
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
For ($i = 0; $i -lt 3; $i++) {
    $vmName = "test-vm-$i"
    New-AzVM `
        -Name $vmName `
        -ResourceGroupName $resourceGroupName `
        -Image $imageName
}
# AZ asks you for your credentials every time
#>
