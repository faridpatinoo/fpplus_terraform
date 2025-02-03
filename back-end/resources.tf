resource "azurerm_resource_group" "backend-resource-group" {
  location = "eastus"
  name     = "fpplus-backend_group"
  tags = {
    "environment" = "backend"
  }
}

resource "azurerm_service_plan" "ASP_backend" {
  name                   = "ASP-fpplusbackendgroup-8e23"
  location               = "East US 2"
  resource_group_name    = azurerm_resource_group.backend-resource-group.name
  os_type                = "Linux"
  sku_name               = "F1"
  zone_balancing_enabled = false
}

# Get a Key Vault to store the password
data "azurerm_key_vault" "terraform_keyvault" {
  name                = "keyvault-fp-plus"
  resource_group_name = azurerm_resource_group.backend-resource-group.name
}

data "azurerm_key_vault_secret" "password_secret" {
  name         = "TF-PASSWORD"
  key_vault_id = data.azurerm_key_vault.terraform_keyvault.id
}

resource "azurerm_linux_web_app" "webapp_backend" {
  location        = azurerm_service_plan.ASP_backend.location
  service_plan_id = azurerm_service_plan.ASP_backend.id

  app_settings = {
    "PASSWORD"                            = data.azurerm_key_vault_secret.password_secret.value
    "PORT"                                = "80"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
  ftp_publish_basic_authentication_enabled = false
  https_only                               = true
  name                                     = "fpplus-backend-docker"
  resource_group_name                      = "fpplus-backend_group"
  tags                                     = {}

  logs {
    detailed_error_messages = false
    failed_request_tracing  = false

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  site_config {
    always_on  = false
    ftps_state = "FtpsOnly"

    application_stack {
      docker_image_name   = "faridpatinoo/fp-plus-back-end-docker:3d5f75d354bed86ae03287139a337aadaec892b2"
      docker_registry_url = "https://index.docker.io"
    }

    cors {
      allowed_origins = [
        "*",
      ]
      support_credentials = false
    }
  }
}
