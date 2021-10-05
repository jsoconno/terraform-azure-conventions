# Azurerm Provider Resource Naming Conventions Module

## Overview

The purpose of this module is to help standardize naming conventions for resources created in Azure using Terraform and the azurerm module.

The basic convention followed is `<unique resource identifier>-<location acronym>-<workload acronym>-<environment acronym>`.  Resources that have constraints on special characters utilize the `replace()` function to remove the `-` from the convention.

The configuration takes in the following arguments:

* `var: location_acronym [string - optional validated - defaults to "use"]` - The acronym for the deployment location.
* `var: workload_acronym [string - required restricted - 8 chararcter limit]` - The acronym for the workload.  This might be an application, project, focus area, or other dimension.  For example, `core`, `app`, or some acronym for an app like `fb` might be common.
* `environment_acronym [string - optional validated - defaults to "d"]` - The acronym for the deployment environment.  For example, `d` for development.
* `var: case [bool - optional validated - defaults to "kabab"]` - Allows the user to set some casing parameters.  Case options include `kabab`, `camel`, and `lower`.

Casing options were added to allow some flexibility over naming, but the default `kabab` case is recommended for its broad support across services and readability.  Case options for `upper`, `snake` and `title` were considered, but there are many resources that don't allow resources to start with an upper case letter or use the `_` character.  For these reasons, all casing supported are those that only use dashes or no spaces with the first letter always being lower case.

Over time, this module will be improved to remove items that do not accept a name attribute and add support for additional providers.

## Example

The best way to take advantage of this module is to create a file with the name `conventions.tf` to hold the naming standards module.  The following code should be added with your specific values.

```terraform
module "conventions" {
  source = "github.com/jsoconno/terraform-module-naming-standards?ref=v0.3.0"

  case = "kabab" # this is optional and set to kabab by default.  shown here for demonstration only.

  location_acronym = "use"
  workload_acronym = "core"
  environment_acronym = "d"
}
```
You can also pass variables to the module from a variables file so that you can make the values different based on your environment.  For example, you might want to parameterize the `environment_acronym` argument so that you can deploy to development with the value `d`, but production with the value `p`.

Another common case might be to have multiple conventions if you need to specific a different workload.  To do this, it is recommended to call the module twice and give it a name that specifies the workload.  For example, you might have `module.conventions_core.azurerm...` and `module.conventions_app.azurerm...`.

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

1. Naming uses the provider name as a baseline

`azurerm_api_management`

2. The provider (e.g. `azurerm`) is dropped from the name and underscores replaces with spaces.

`azurerm api management`

3. If the name of the service is a single word then the first three letters of the service are used.

`attestation` = `att`


4. If the name of the service has multiple words the first letters of each word are used.

`api management` = `am`

5. If multiple resources have the same acronym then the first resource alphabetically retains the baseline acronym and the subsequent resources alphabetically adds additional letters from the last name of ther service.

`api management` conflicts with `automation module` for the acronym `am` so `api management` gets `am` and `automation module` gets `amo`.