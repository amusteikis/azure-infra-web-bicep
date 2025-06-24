param storageAccountId string
param diagName string = 'diag-app-service'
param targetResourceId string

// Declarar el recurso existente para usarlo como scope
resource targetResource 'Microsoft.Web/sites@2022-03-01' existing = {
  name: 'web-infra-dev-01'
}

resource diagSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagName
  scope: targetResource // ⬅️ Se usa como scope el recurso existente
  properties: {
    workspaceId: null
    storageAccountId: storageAccountId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    logAnalyticsDestinationType: 'AzureDiagnostics'
  }
}
