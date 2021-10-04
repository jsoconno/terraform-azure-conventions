# Terraform Module: Naming Conventions

## Overview

This module is intended to offer a convenient way of addressing the issue of inconsistent naming standards for resources in cloud providers.

The configuration takes in a small number of values and uses that to construct a standard naming convention that can be referenced for any resource that is available in the module.

## Example

The best way to take advantage of this module is to reference it in its own file called naming-standards.tf with the following code...

```terraform
module "conventions" {
  source = "github.com/jsoconno/terraform-module-naming-standards"

  location_acronym = "use"
  workload_acronym = "core"
  environment_acronym = "d"
}
```

... and then use it in a configuration like the example below:

```terraform
resource "azurerm_app_service_plan" "core" {
  name                = module.conventions.azurerm_app_service_plan
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name

  sku {
    tier = "Free"
    size = "F1"
  }

  tags = var.tags
}
```

## Logic

To keep the naming as simple to understand as possible, the following logic was implemented:

* Naming uses the provider name as a baseline (e.g. `azurerm_api_management`).
* The provider (e.g. `azurerm`) is dropped from the name and underscores replaces with spaces.
* If the name of the service is a single word (e.g. `attestation`) then the first three letters of the service are used (e.g. `att`).
* If the name of the service has multible words (e.g. `api management`) the first letters of each word are used (e.g. `am`).
* If multiple resources have the same acronym (e.g. `automation module` conflicts with `api management` for the acronym `am`) then the first resource alphabetically retains the acronym (e.g. `api management` is `am`) and the subsequent resources alphabetically add additional letters from the last name of ther service (e.g. `automation module` would become `amo`).