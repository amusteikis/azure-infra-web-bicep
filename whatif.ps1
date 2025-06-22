#what-if

# Resource Group Name
$resourceGroup = "rg-webapp-infra-dev"

# folder where the ARM template is located
$templateFile = ".\main.bicep" 
$parametersFile = ".\main.parameters.json"

Write-Host "Starting what-if analysis for Azure resources..." -ForegroundColor Cyan

az deployment group what-if `
    --resource-group $resourceGroup `
    --template-file $templateFile `
    --parameters @$parametersFile `

Write-Host "What-if analysis initiated. You can check the results in the Azure portal." -ForegroundColor Green
