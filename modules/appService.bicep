param webAppName string
param location string = resourceGroup().location
param appServicePlanId string

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.10' // Specify the Python version
    }
    httpsOnly: true // Enforce HTTPS
  }
  kind: 'app,linux' // Specify the kind for Linux app service
  }

  output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
