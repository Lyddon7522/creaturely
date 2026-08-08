targetScope = 'resourceGroup'

var location = 'Central US'
var skuName = 'Free'
var staticWebAppName = 'creaturely-prod-swa-01'

var tags = {
  application: 'creaturely-site'
  environment: 'prod'
  managedBy: 'bicep'
}

module staticWebApp 'static-web-app.bicep' = {
  name: 'creaturely-site-static-web-app'
  params: {
    location: location
    name: staticWebAppName
    skuName: skuName
    tags: tags
  }
}

output defaultHostname string = staticWebApp.outputs.defaultHostname
output staticWebAppId string = staticWebApp.outputs.id
output staticWebAppName string = staticWebApp.outputs.name
