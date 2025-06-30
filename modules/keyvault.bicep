
param location string
param keyVaultName string
param secretName string
@secure()
param secretValue string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard' // Standard SKU
      family: 'A' // Family A for standard vaults
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enableSoftDelete: true // Enable soft delete for recovery
  }
}

resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  name: secretName
  parent: keyVault
  properties: {
    value: secretValue
  }
}

output secretUri string = kvSecret.properties.secretUriWithVersion
