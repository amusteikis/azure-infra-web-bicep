# deploy.ps1

# Resource Group Name
$resourceGroup = "rg-webapp-infra-dev"

# folder where the ARM template is located
$templateFile = ".\main.bicep"
$parametersFile = ".\main.parameters.json"

Write-Host "Starting deployment of Azure resources..." -ForegroundColor Cyan

az deployment   group create `
    --resource-group $resourceGroup `
    --template-file $templateFile `
    --parameters $parametersFile `
    --no-wait

Write-Host "Deployment initiated. You can check the status in the Azure portal." -ForegroundColor Green

