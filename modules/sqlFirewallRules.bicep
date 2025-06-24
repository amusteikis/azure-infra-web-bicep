param sqlServerName string
param startIp string = '186.182.86.0'
param endIp string = '186.182.86.255'

resource sqlServer 'Microsoft.Sql/servers@2022-02-01' existing = {
  name: sqlServerName
}

resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  name: 'AllowCorpIpRange'
  parent: sqlServer
  properties: {
    startIpAddress: startIp
    endIpAddress: endIp
  }
}
