# Terraform Module: Naming Standards

This module is intended to offer a convenient way of addressing the issue of inconsistent naming standards for resources in cloud providers.

The configuration takes in a small number of values and uses that to construct a standard naming convention that can be referenced for any resource that is available in the module.

The best way to take advantage of this module is to reference it in its own file called naming-standards.tf with the following code...

```terraform
module "naming_standards" {
  source = "github.com/jsoconno/terraform-module-naming-standards"

  location_acronym = "use"
  workload_acronym = "core"
  environment_acronym = "d"
}
```

... and then use it in a configuration like the example below:

```terraform
resource "azurerm_app_service_plan" "core" {
  name                = module.naming_standards.azurerm_app_service_plan
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name

  sku {
    tier = "Free"
    size = "F1"
  }

  tags = var.tags
}
```