@description('Name of the web application')
param webAppName string
@description('Location for the web application')
param location string
@description('ID of the App Service Plan')
param appServicePlanId string
@description('Key Vault secret URI for the connection string')
param secretUri string
@description('Application Insights connection string')
param appInsightsConnectionString string

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'app,linux' // Specify the kind for Linux app service
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true // Enforce HTTPS
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.10' // Specify the Python version
      appSettings: [
        {
          name: 'SQL_CONNECTION_STRING'
          value: '@Microsoft.KeyVault(SecretUri=${secretUri})' // Reference the Key Vault secret
        }
        {  
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString // Reference the Application Insights connection string
        }
      ]
    }
  }
  
}
output webAppName string = webApp.name
output webAppId string = webApp.id


