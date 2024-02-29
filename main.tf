terraform {    
  required_providers {    
    azurerm = {    
      source = "hashicorp/azurerm"    
    }    
  }    
} 
   
provider "azurerm" {    
  features {}    

  subscription_id = "23c14808-504c-4ae4-91cb-2a2f2f6cb725"
  tenant_id       = "9e90a546-532f-4ccb-a93e-3384b6c0661b"


}

resource "azurerm_resource_group" "resource_group" {
  name     = "webapp-containers-demo"
  location = "northeurope"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "ASP-waluregroup-9613"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  # Define Linux as Host OS
  kind = "Linux"
  reserved = true  # Set reserved to true for Linux App Service Plans

  # Choose size
  sku {
    tier = "Basic"
    size = "B1"
    capacity = 1    
  }

}


resource "azurerm_app_service" "app_service" {
  name                = "rezumiistaging"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id


  app_settings = {
   WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "rezumii.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = "rezumii"
    DOCKER_REGISTRY_SERVER_PASSWORD = "cRN/vTFYQUke8+FCHf87NQIyVH3QxEwu9KgxPa4jSO+ACRD5fmoH"

    Azure__Blob__Connection__String = "DefaultEndpointsProtocol=https;AccountName=rezumii;AccountKey=hmm+cko0lGiK+2/pAkTLrIRFRJpAOCUp9ve3+IcZxUiBTpikX0hX0jJWM4UyOT9CA2EaYYWz72nn+ASt3nrSCg==;EndpointSuffix=core.windows.net"
    Azure__Blob__Container__Name = "assets"
    AzureBusHostName = "Endpoint=sb://rezumii.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=W3szw514EFsfe2ktgc7KqeGTu0qEHvivePOWAATpba0="
    FileCertificate__Password = "Lk9d2MeSN4qafFUm8zQB"
    


  
  }
  # Configure Docker Image to load on start
  site_config {
    linux_fx_version = "DOCKER|rezumii.azurecr.io/apigateway:latest"
    always_on        = "true"
  }

}

