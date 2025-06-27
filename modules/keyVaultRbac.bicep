param keyVaultName string
param principalId string // Managed identity principal ID to assign RBAC role
param location string

resource keyVault 'Microsoft.Keyvault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, principalId, 'Key Vault Secrets User')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Key Vault Secrets User role
    principalId: principalId
  principalType: 'ServicePrincipal' // Assuming the principal is a managed identity
  }

}
