@description('Set to true if you want to deploy Azure SQL resources')
param deploySql bool = false
param location string = 'westeurope' // Default location, can be overridden
param sqlServerName string
param sqlDbName string
param adminUserName string
@secure()
param adminPassword string
param keyVaultName string
param secretName string
@secure()
param connectionString string // Connection string to be stored in Key Vault
param appInsightsName string


module storageAccount './modules/generic-storageAccount.bicep' = {
  name: 'storageAccountModule'
  params: {
    skuName: 'Standard_LRS' // Default to Standard Locally Redundant Storage
    kind: 'StorageV2' // Default to StorageV2
    location: location
    storageAccountName: 'stinfraweb${uniqueString(resourceGroup().id)}' // Unique name for the storage account
  }
}   

module appServicePlanModule './modules/generic-appServicePlan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    name: 'my-asp-${uniqueString(resourceGroup().id)}' // Unique name for the App Service Plan
    location: location  
    sku: {
      name: 'P1v2' // Premium V2 tier
      tier: 'PremiumV2'
      size: 'P1v2'
      capacity: 1 // Default capacity
    }
    isLinux: true // Set to true for Linux App Service Plan
  }
}


module appServiceModule './modules/generic-appservice.bicep' = {
  name: 'deployAppService'
  params: {
    webAppName: 'web-infra-dev-${uniqueString(resourceGroup().id)}' // Unique name for the web application
    location: location
    appServicePlanId: appServicePlanModule.outputs.appServicePlanId
    secretUri: keyVaultModule.outputs.secretUri // Pass the Key Vault secret URI to the app service
    appInsightsConnectionString: appInsightsModule.outputs.connectionString // Pass the Application Insights connection string
  }
}

output webAppId string = appServiceModule.outputs.webAppId

module sqlServerModule './modules/generic-sqlServer.bicep' = {
  name: 'sqlServerModule'
  params: {
    sqlServerName: sqlServerName
    location: location
    adminUserName: adminUserName
    adminPassword: adminPassword
  }
}

module sqlDbModule './modules/generic-sqlDatabase.bicep' = {
  name: 'sqlDbModule'
  params: {
    sqlDbName: sqlDbName
    sqlServerName: sqlServerModule.outputs.sqlServerName
    location: location
  }
}

module keyVaultModule './modules/generic-keyvault.bicep' = {
  name: 'deployKeyVault'
  params: {
    location: location
    keyVaultName: keyVaultName
    secretName: secretName
    secretValue: connectionString
  }
}

module appInsightsModule './modules/appInsights.bicep'= {
  name: 'deployAppInsights'
  params: {
    location: location
    appInsightsName: appInsightsName
  }
}


module sqlFirewall 'modules/sqlFirewallRules.bicep' = if (deploySql) {
  name: 'sqlFirewallRule'
  params: {
    sqlServerName: sqlServerModule.outputs.sqlServerName
    startIp: '186.182.86.0'
    endIp: '186.182.86.255'
  }
}
/*
module kvFirewall 'modules/keyVaultFirewall.bicep' = {
  name: 'keyVaultFirewallRule'
  dependsOn: [
    keyVaultModule
  ]
  params: {
    keyVaultName: keyVaultName
    ipRange: '186.182.86.0/24'
  }
}
*/
// Optional Module: SQL private Endpoint
/*
module sqlPrivateEndpoint 'modules/privateEndpointSql.bicep' = {
  name: 'sqlPrivateEndpoint'
  params: {
    location: location
    sqlServerName: sqlModule.outputs.name
    vnetName: 'myVnet' // Replace with your VNet name
    subnetName: 'mySubnet' // Replace with your subnet name
    enablePrivateEndpoint: false // Set to true if you want to enable private endpoint=
  }
}

*/

/*
module keyVaultRbac './modules/keyVaultRbac.bicep' = {
  name: 'keyVaultRbac'
  params: {
    keyVaultName: keyVaultName
    principalId: appServiceModule.outputs.principalId // Assuming the principal is the App Service's managed identity
    location: location
  }
}

*/
output sqlConnectionStringFromKeyVault string = keyVaultModule.outputs.secretUri
