param appServicePlanName string
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1' // Free tier
    tier: 'Free'
  }
  kind: 'linux' // Change to 'linux' for Linux plans, or 'app' for Windows plans
  properties: {
    reserved: true // Set to true for Linux plans
  }
}

output appServicePlanId string = appServicePlan.id 
