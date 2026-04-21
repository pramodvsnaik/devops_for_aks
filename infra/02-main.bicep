targetScope = 'subscription'
param rgName string = 'rg-landingzone'
param location string = 'centralus'
param vnetName string = 'vnet-landingzone'
param vnetAddressPrefix string = '10.0.0.0/16'
param subnetName string = 'snet-landingzone'
param subnetAddressPrefix string = '10.0.0.0/24'
param acrName string = 'acrlandingzone'
param kvName string = 'kv-landingzone'
param stoName string = 'stolandingzone'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: acrName
  location: location
  scopes: [
    rg.id
  ]
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

