locals {
  convention = var.business_unit == "" ? "-${lower(var.region)}-${lower(var.environment)}-${lower(var.workload)}" : "-${lower(var.region)}-${lower(var.environment)}-${lower(var.business_unit)}-${lower(var.workload)}"
}

resource "null_resource" "conventions" {

}