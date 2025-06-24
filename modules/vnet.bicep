param location string
param vnetName string = 'vnet-dev'
param addressPrefix string = '10.0.0.0/16'
param subnetName string = 'snet-private-endpoints'
param subnetPrefix string = '10.0.1.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets:[
      {
        name: subnetName
        properties:{
          addressPrefix: subnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          delegations: [
            {
            name: 'delegation-sql'
            propierties: {
              serviceName: 'Microsoft.Sql/servers'
            }
            }
          ]
        }
      }
    ]
  }
}
