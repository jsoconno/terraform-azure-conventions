locals {
  convention = var.business_unit == "" ? "-${lower(var.workload)}-${lower(var.environment)}-${lower(var.region)}" : "-${lower(var.workload)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.business_unit)}"
}

resource "null_resource" "conventions" {

}