output "secret_value" {
  value     = data.azurerm_key_vault_secret.password_secret.value
  sensitive = true
}
