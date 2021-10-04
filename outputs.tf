output "azurerm_windows_virtual_machine" {
    value = "vm-${local.convention}"
}

output "azurerm_app_service_plan" {
    value = "asp-${local.convention}"
}