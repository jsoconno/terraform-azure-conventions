locals {
  convention = "${lower(var.location_acronym)}-${lower(var.workload_acronym)}-${lower(var.environment_acronym)}"
}

resource "null_resource" "naming_standards" {

}