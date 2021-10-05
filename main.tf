locals {
  convention = var.lowercase ? "${lower(var.location_acronym)}-${lower(var.workload_acronym)}-${lower(var.environment_acronym)}" : "${var.location_acronym}-${var.workload_acronym}-${var.environment_acronym}"
}

resource "null_resource" "naming_standards" {

}