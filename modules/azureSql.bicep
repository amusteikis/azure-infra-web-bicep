param location string
param sqlServerName string
param sqlDbName string
param adminUserName string
@secure()
param adminPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: adminUserName
    administratorLoginPassword: adminPassword
    version: '12.0' // SQL Server version
  }
}
 

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: sqlDbName
  parent: sqlServer
  location: location
  sku: {
    name: 'Basic' // Basic tier for testing
    tier: 'Basic'
    capacity: 5 // 5 DTUs
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS' // Default collation
    maxSizeBytes: 2147483648 // 2 GB max size
  }
}

output name string = sqlServer.name
