# Moving a resource from one resource group to another
# Store credentials for convenience
$cred = Get-Credential

# Create two new resource groups for this exercise
New-AzResourceGroup -Name test0 -Location 'Korea Central'
New-AzResourceGroup -Name test1 -Location 'Korea Central'

# Create a VM (with associated resources) in the first resource group
New-AzVM -ResourceGroupName test0 -Name vm0 -Image UbuntuLTS -Credential $cred

# Gather all VM-related resources you created
$vmResources = Get-AzResource -ResourceGroupName test0 -Name vm0
$vmResources | ForEach-Object { Write-Host $_.ResourceGroupName }

<#
- Initiate the move from the first resource group to the other
- This move takes quite a long time
- You can observe resources appearing in one resource group, and disappearing
  from the previous resource group in real time through the Azure Portal
#>
$vmResources | ForEach-Object { Move-AzResource -DestinationResourceGroupName test1 -ResourceId $_.ResourceId -Force }

# Confirm that the resources were moved (output should be blank)
$vmResources = Get-AzResource -ResourceGroupName test0 -Name vm0
$vmResources | ForEach-Object { Write-Host $_.ResourceGroupName }

# Confirm that the resources were moved (output should contain info on a couple resources)
$vmResources = Get-AzResource -ResourceGroupName test1 -Name vm0
$vmResources | ForEach-Object { Write-Host $_.ResourceGroupName }

# Initiate the move back to the original resource group
$vmResources | ForEach-Object { Move-AzResource -DestinationResourceGroupName test0 -ResourceId $_.ResourceId -Force }

# Confirm that the resources were moved (output should be blank)
$vmResources = Get-AzResource -ResourceGroupName test1 -Name vm0
$vmResources | ForEach-Object { Write-Host $_.ResourceGroupName }

# Confirm that the resources were moved (output should contain info on a couple resources)
$vmResources = Get-AzResource -ResourceGroupName test0 -Name vm0
$vmResources | ForEach-Object { Write-Host $_.ResourceGroupName }

# Clean up all resources after this exercise is finished
Remove-AzResourceGroup -Name test0 -Force
Remove-AzResourceGroup -Name test1 -Force