
param webAppName string
param location string = resourceGroup().location
param appServicePlanId string
param secretUri string
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
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.10' // Specify the Python version
      appSettings: [
        {
          name: 'SQL_CONNECTION_STRING'
          value: '@Microsoft.KeyVault(SecretUri=${secretUri})' // Reference the Key Vault secret}
        }
        {  
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString // Reference the Application Insights connection string
    }
  ]
  }
  httpsOnly: true // Enforce HTTPS

  }
}


output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
output resourceId string = webApp.id
output principalId string = webApp.identity.principalId
