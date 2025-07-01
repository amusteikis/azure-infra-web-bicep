
# 🌐 Azure Infra Web – Modular Infrastructure with Bicep

A complete modular infrastructure template for deploying a web application on Azure using Bicep. Designed for reusability, automation, and clean deployment via CI/CD pipelines.

![Architecture Diagram](./azure_bicep_diagram.png)

---

## ✨ Highlights

- 🔹 Fully modularized with reusable Bicep modules
- 🔹 Supports App Service, SQL, Key Vault, Storage, Monitoring
- 🔹 Azure DevOps CI/CD ready (with pipeline YAML)
- 🔹 Built-in support for parameterized deployments
- 🔹 `what-if` safe-mode validation script included

---

## 🧱 Module Structure

| Module | Resource |
|--------|----------|
| `generic-appServicePlan.bicep` | App Service Plan |
| `generic-appService.bicep`     | Linux Web App |
| `generic-keyvault.bicep`       | Key Vault with Secret |
| `generic-storageAccount.bicep` | Storage Account |
| `generic-sqlServer.bicep`      | Azure SQL Server |
| `generic-sqlDatabase.bicep`    | Azure SQL Database |
| `diagnosticSettings.bicep`     | Diagnostic Settings for Web App |
| `keyVaultRbac.bicep`           | (Optional) Role Assignment |
| `sqlFirewallRules.bicep`       | SQL IP Firewall Rules |
| `privateEndpointSql.bicep`     | (Optional) SQL Private Endpoint |
| `vnet.bicep`                   | (Optional) Basic VNet |

---

## ⚙️ Requirements

- Azure CLI installed
- PowerShell for local scripts
- Azure DevOps (optional) or GitHub Actions
- Valid Azure subscription with quota (or sandbox)

---

## 🚀 How to Deploy

### 🔍 Step 1 – Safe preview with `what-if`

```bash
./whatif.ps1
```

This will simulate the entire deployment and show what will change.

---

### 🚀 Step 2 – Deploy with Azure CLI

```bash
az deployment group create \
  --resource-group rg-webapp-infra-dev \
  --template-file main.bicep \
  --parameters @main.parameters.json
```

You can adapt the parameters file for different environments.

---

## 📁 Project Structure

```
azure-infra-web-bicep/
│
├── main.bicep                # Entry point for deployment
├── main.parameters.json      # Parameters file
├── whatif.ps1                # Simulated deployment
├── azure-pipelines.yml       # Azure DevOps CI/CD pipeline
├── modules/                  # Reusable Bicep modules
│   ├── generic-appService.bicep
│   ├── generic-keyvault.bicep
│   ├── generic-sqlServer.bicep
│   └── ...
└── README.md
```

---

## 🔁 Reusability

You can use this template as a base for:

- Dev/Test/Prod environments
- Multi-region deployments
- Client infrastructure automation

Just plug in new parameters and deploy with confidence.

---

## 👤 Author

Developed by [@amustekis](https://github.com/amustekis) as part of a professional DevOps & Azure Cloud portfolio.  
Feel free to fork, reuse, and adapt.

---

## 📦 Download

- [📁 Project ZIP](./azure-infra-web-bicep.zip)
- Clone: `git clone https://github.com/amustekis/azure-infra-web-bicep.git`

---

## 📝 License

MIT — Free to use, modify and distribute.
