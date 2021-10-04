# Naming Standards Terraform Module

## Overview

The purpose of this module is to help standardize naming conventions for resources when using cloud providers.  See the list of supported providers below:

* `azurerm`

The configuration takes in the following values:

* `location_acronym` - The acronym for the deployment location.  This is a validated field.
* `workload_acronym` - The acronym for the workload.  This might be an application, project, focus area, or other item.  This is a freeform field with a limited length.
* `environment_acronym` - The acronym for the deployment environment.  For example, `d` for development.  This is a validated field.

These values are used to construct a standard naming convention that can be referenced for any resource that is available.

Over time, this module will be improved to remove items that do not accept a name attribute and add support for additional providers.

## Example

The best way to take advantage of this module is to create a file with the name conventions.tf to hold the naming standards module.  The following code should be added with your specific values.

```terraform
module "conventions" {
  source = "github.com/jsoconno/terraform-module-naming-standards?ref=v0.1.1"

  location_acronym = "use"
  workload_acronym = "core"
  environment_acronym = "d"
}
```
You can also pass variables to the module from a variables file so that you can make the values different based on your environment.  For example, you might want to parameterize the `environment_acronym` variable so that you can deploy to development with the value `d`, but production with the value `p`.

Once the module is declared you can use it with any supported resource by calling the module and referencing the provider resource type.

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
The module is written so that the name of the provider resource will always match the name of the convention so it is simple to reference.  For example, to use the proper naming convention for a subnet when using the azurerm provider you would use `module.conventions.azurerm_subnet`.
## Logic

To keep the naming as simple to understand as possible, the following logic was implemented:

* Naming uses the provider name as a baseline (e.g. `azurerm_api_management`).
* The provider (e.g. `azurerm`) is dropped from the name and underscores replaces with spaces.
* If the name of the service is a single word (e.g. `attestation`) then the first three letters of the service are used (e.g. `att`).
* If the name of the service has multible words (e.g. `api management`) the first letters of each word are used (e.g. `am`).
* If multiple resources have the same acronym (e.g. `automation module` conflicts with `api management` for the acronym `am`) then the first resource alphabetically retains the acronym (e.g. `api management` is `am`) and the subsequent resources alphabetically adds additional letters from the last name of ther service (e.g. `automation module` would become `amo`).

## Change Log

`v0.1.0` - The initial version of the standards was implemented for all avalable resources in the azurerm provider.  This includes resources that don't have a name attribute for simplicity to start.  This version was broken due to some malformatted `replace()` functions.
`v0.1.1` - This version fixes the previously mentioned bug by updating the resources whos naming convention relied on the `replace()` function.