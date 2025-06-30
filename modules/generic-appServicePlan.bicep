@description('Name of the App Service Plan')
param name string
@description('Location for the App Service Plan')
param location string
@description('SKU for the App Service Plan')
param sku object = {
  name: 'P1v2' // Default to Basic tier
  tier: 'PremiumV2'
  size: 'P1v2'
  family: 'Pv2'
  capacity: 1 // Default capacity
}

@description('Whether the App Service Plan is for Linux')
param isLinux bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: sku
  kind: isLinux ? 'linux' : 'app'
  properties: {
    reserved: isLinux // Set to true for Linux plans
  }
}

output appServicePlanName string = appServicePlan.name
output appServicePlanId string = appServicePlan.id
