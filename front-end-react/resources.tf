resource "azurerm_resource_group" "fpplus_react_rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = "frontend"
  }
}

resource "azurerm_service_plan" "fpplus_react_sp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.fpplus_react_rg.name
  location            = "East US 2"
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "fpplus_react_wa" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.fpplus_react_rg.name
  location            = azurerm_service_plan.fpplus_react_sp.location
  service_plan_id     = azurerm_service_plan.fpplus_react_sp.id
  app_settings = {
    "DOCKER_ENABLE_CI" = "true"
    #"DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io/v1"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
  https_only = true

  logs {
    detailed_error_messages = false
    failed_request_tracing  = false

    http_logs {
      file_system {
        retention_in_days = 3
        retention_in_mb   = 100
      }
    }
  }

  site_config {
    always_on = false
    application_stack {
      docker_image_name   = "faridpatinoo/fp-plus-docker:latest"
      docker_registry_url = "https://index.docker.io"
    }
  }


  timeouts {}
}
