
param keyVaultName string
param ipRange string = '186.182.86.0/24'

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource kvFirewallRule 'Microsoft.KeyVault/vaults/firewallRules@2022-07-01' = {
  name: 'default'
  parent: keyVault
  properties: {
    defaultAction: 'Deny' // Deny all by default
    bypass: 'AzureServices' // Allow Azure services to bypass the firewall
    ipRules: [
      {
        value: ipRange // Specify the IP range to allow
      }
    ]
  }
}
