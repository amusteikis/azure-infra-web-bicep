@description('Set to true if you want to deploy Azure SQL resources')
param deploySql bool = false
param location string = 'westeurope' // Default location, can be overridden
param storageAccountName string
param appServicePlanName string
param webAppName string
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


module storageAccount './modules/storage.bicep' = {
  name: 'deployStorage'
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}   

module appServicePlanModule './modules/appServicePlan.bicep' = {
  name: 'deployAppServicePlan'
  params: {
    appServicePlanName: appServicePlanName
    location: location  
  }
}


module appServiceModule './modules/appService.bicep' = {
  name: 'deployAppService'
  params: {
    webAppName: webAppName
    location: location
    appServicePlanId: appServicePlanModule.outputs.appServicePlanId
    secretUri: keyVaultModule.outputs.secretUri // Pass the Key Vault secret URI to the app service
    appInsightsConnectionString: appInsightsModule.outputs.connectionString // Pass the Application Insights connection string
  }
}

output webAppUrl string = appServiceModule.outputs.webAppUrl

module sqlModule 'modules/azureSql.bicep' = if (deploySql) {
  name: 'deployAzureSql'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlDbName: sqlDbName
    adminUserName: adminUserName
    adminPassword: adminPassword
  }
}

module keyVaultModule './modules/keyvault.bicep' = {
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

module diagSettingsModule './modules/diagnosticSettings.bicep' = {
  name: 'deployDiagnosticSettings'
  params: {
    targetResourceId: appServiceModule.outputs.resourceId
    storageAccountId: storageAccount.outputs.resourceId
    diagName: 'diag-webapp-v2'
  }
}

module sqlFirewall 'modules/sqlFirewallRules.bicep' = if (deploySql) {
  name: 'sqlFirewallRule'
  params: {
    sqlServerName: sqlModule.outputs.name
    startIp: '186.182.86.0'
    endIp: '186.182.86.255'
  }
}

module kvFirewall 'modules/keyVaultFirewall.bicep' = {
  name: 'keyVaultFirewallRule'
  params: {
    keyVaultName: keyVaultName
    ipRange: '186.182.86.0/24'
  }
}

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

module keyVaultRbac './modules/keyVaultRbac.bicep' = {
  name: 'keyVaultRbac'
  params: {
    keyVaultName: keyVaultName
    principalId: appServiceModule.outputs.principalId // Assuming the principal is the App Service's managed identity
    location: location
  }
}
output sqlConnectionStringFromKeyVault string = keyVaultModule.outputs.secretUri
