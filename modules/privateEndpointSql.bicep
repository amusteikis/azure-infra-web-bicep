
param location string
param sqlServerName string
param vnetId string
param subnetName string
@description('Enable or not the private endpoint connection')
param enablePrivateEndpoint bool = false

resource sqlServer 'Microsoft.Sql/servers@2022-02-01' existing = {
  name: sqlServerName
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = if (enablePrivateEndpoint) {
  name: '${sqlServerName}-privateEndpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnetId}/subnets/${subnetName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'sqlServerConnection'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
          requestMessage: 'Please approve the private endpoint connection.'
        }
      }
    ]
  }
}
