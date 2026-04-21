
write-host "Loading environment variables from .env file"

Get-Content ..\.env | foreach {
  $name, $value = $_ -split '='
  Set-Content -Path env:$name -Value $value
  
}
Write-Host $env:AKS_NAME
Write-Host $env:AZURE_SUBSCRIPTION_ID
Write-Host $env:LOCATION
Write-Host $env:RESOURCE_GROUP

az login --service-principal -u $env:AZURE_APP_ID -p $env:AZURE_SECRET --tenant $env:AZURE_TENANT_ID -o none
az account set --subscription $env:AZURE_SUBSCRIPTION_ID -o none


