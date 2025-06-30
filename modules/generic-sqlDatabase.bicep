@description('Sql Database name')
param sqlDbName string
@description('Sql Server name')
param sqlServerName string 
@description('location for the SQL Database')
param location string 

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServerName}/${sqlDbName}'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 5
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
    zoneRedundant: false
  }
}

output sqlDbName string = sqlDatabase.name
output sqlDbId string = sqlDatabase.id
