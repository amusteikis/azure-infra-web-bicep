@description('Sql Server name')
param sqlServerName string
@description('location for the SQL Server')
param location string 
@description('adminUserName for the SQL Server')
param adminUserName string
@description('adminPassword for the SQL Server')
@secure()
param adminPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: adminUserName
    administratorLoginPassword: adminPassword
    version: '12.0' // SQL Server version
    publicNetworkAccess: 'Enabled' // Enable public network access
    minimalTlsVersion: '1.2' // Set minimum TLS version to 1.2
  }
}

output sqlServerName string = sqlServer.name
output sqlServerId string = sqlServer.id 
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
