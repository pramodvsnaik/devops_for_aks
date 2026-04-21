[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $appdevops_group_name,
    [Parameter(Mandatory = $true)]
    [string]
    $admin_group_name
)

& ".\00-load-env.ps1"



az ad group create `
 --display-name $appdevops_group_name `
 --mail-nickname $appdevops_group_name


az ad group create `
 --display-name $admin_group_name `
 --mail-nickname $admin_group_name


#Add SPN to groups
az ad group member add `
  --group $appdevops_group_name `
  --member-id $env:AZURE_OBJ_ID

az ad group member add `
 --group $admin_group_name `
 --member-id $env:AZURE_OBJ_ID

 az ad group owner add `
 --group $admin_group_name `
 --owner-object-id $env:AZURE_OBJ_ID

 
 az ad group owner add `
 --group $appdevops_group_name `
 --owner-object-id $env:AZURE_OBJ_ID

