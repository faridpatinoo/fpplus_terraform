#resource_group
variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
  default     = "fpplus-frontend_group"
}

variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
  default     = "East US"
}

#app_service_plan
variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
  default     = "fpplus-appserviceplan-front-end"
}

#web_app
variable "web_app_name" {
  description = "The name of the Web App."
  type        = string
  default     = "fp-plus-react-terraform"
}
