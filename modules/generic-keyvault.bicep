@description('Keyvault name')
param keyVaultName string
@description('Location for the Keyvault')
param location string 
@description('Secret name to store in the Keyvault')
param secretName string
@description('Secret value to store in the Keyvault')
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
    enableRbacAuthorization: true // Enable RBAC for access control
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
output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
