param location string = 'westeurope' // Default location, can be overridden
param storageAccountName string
param appServicePlanName string
param webAppName string

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
  }
}

output webAppUrl string = appServiceModule.outputs.webAppUrl
