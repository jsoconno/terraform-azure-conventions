locals {
  convention = var.case == "kabab" ? "-${lower(var.location_acronym)}-${lower(var.environment_acronym)}-${lower(var.workload_acronym)}" : var.case == "camel" ? "${title(var.location_acronym)}${title(var.environment_acronym)}${title(var.workload_acronym)}" : "${lower(var.location_acronym)}${lower(var.environment_acronym)}${lower(var.workload_acronym)}"
}

resource "null_resource" "conventions" {

}