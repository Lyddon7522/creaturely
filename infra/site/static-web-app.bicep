targetScope = 'resourceGroup'

@description('Azure region for the Static Web App.')
param location string

@description('The Static Web App resource name.')
param name string

@allowed([
  'Free'
  'Standard'
])
@description('The Static Web App SKU name and tier.')
param skuName string = 'Free'

@description('Tags applied to the Static Web App.')
param tags object = {}

resource staticWebApp 'Microsoft.Web/staticSites@2025-03-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuName
  }
  properties: {
    allowConfigFileUpdates: true
    publicNetworkAccess: 'Enabled'
    stagingEnvironmentPolicy: 'Enabled'
  }
}

output defaultHostname string = staticWebApp.properties.defaultHostname
output id string = staticWebApp.id
output name string = staticWebApp.name
