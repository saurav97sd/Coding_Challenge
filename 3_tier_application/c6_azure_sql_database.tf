# Azure sql database
# The following terraform document shows how we can create MS SQL Server
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server

resource "azurerm_mssql_server" "azuresql" {
  name                         = "test-sqldb-prod"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "4adminu$er"
  administrator_login_password = "randompa$$word"
}

# Creating Azure MS SQL Database
# The following document shows how we can create the database
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database

resource "azurerm_mssql_database" "fg-database" {
  name           = "test-db"
  server_id      = azurerm_mssql_server.azuresql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    Application = "3tier_app"
    Env         = "Prod"
  }
}

# Add VNet Rule
# It allows to manage rules for allowing traffic between an Azure SQL server and a subnet of a virtual network.
# Following document shows how to create this resource-
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule

resource "azurerm_mssql_virtual_network_rule" "allow-be" {
  name      = "be-sql-vnet-rule"
  server_id = azurerm_mssql_server.azuresql.id
  subnet_id = azurerm_subnet.be-subnet.id
  depends_on = [
    azurerm_mssql_server.azuresql
  ]
}
