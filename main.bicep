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

module sqlModule 'modules/azureSql.bicep' = {
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

output sqlConnectionStringFromKeyVault string = keyVaultModule.outputs.secretUri
