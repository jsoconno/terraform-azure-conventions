locals {
    convention = "${var.location_acronym}-${var.workload_acronym}-${var.environment_acronym}"
}

resource null_resource "naming_standards" {
    
}