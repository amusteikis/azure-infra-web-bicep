@description('Name of the App Service Plan')
param storageAccountName string
@description('Location for the storage account')
param location string 
@description('SKU for the storage account')
param skuName string = 'Standard_LRS' // Default to Standard Locally Redundant Storage
@description('Kind of the storage account')
param kind string = 'StorageV2' // Default to StorageV2

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    allowBlobPublicAccess: false // Disable public access to blobs
    minimumTlsVersion: 'TLS1_2' // Enforce TLS 1.2
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name

