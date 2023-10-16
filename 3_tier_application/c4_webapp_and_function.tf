# Frontend
# Create the web app, pass in the App Service Plan ID
# The following terraform document shows how to create linux web app -
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#example-usage

resource "azurerm_linux_web_app" "fe-webapp" {
  name                  = "fitnessgeek"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.fe-asp.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    always_on = true

    application_stack {
      node_version = "16-lts"
    }
  }
  
}

# Backend
# storage account for functionapp
# The following document shows how can we create a strorage group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_storage_account" "fn-storageaccount" {
  name                     = "functionappsa2023"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# The following terraform document shows how can we create a Azure Linux Function App
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app

resource "azurerm_linux_function_app" "be-fnapp" {
  name                = "be-function-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.fn-storageaccount.name
  storage_account_access_key = azurerm_storage_account.fn-storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.be-asp.id

  site_config {

  ip_restriction {
          virtual_network_subnet_id = azurerm_subnet.fe-subnet.id
          priority = 100
          name = "Frontend access only"
           }
  application_stack {
      python_version = 3.8
    }
  }

 depends_on = [
   azurerm_storage_account.fn-storageaccount
 ]
}

#vnet integration of backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "be-vnet-integration" {
  app_service_id = azurerm_linux_function_app.be-fnapp.id
  subnet_id      = azurerm_subnet.be-subnet.id
  depends_on = [
    azurerm_linux_function_app.be-fnapp
  ]
}

#vnet integration of backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "fe-vnet-integration" {
  app_service_id = azurerm_linux_web_app.fe-webapp.id
  subnet_id      = azurerm_subnet.fe-subnet.id

  depends_on = [
    azurerm_linux_web_app.fe-webapp
  ]
}