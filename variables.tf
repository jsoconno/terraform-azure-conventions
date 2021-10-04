variable "location_acronym" {
  default     = "use"
  type        = string
  description = "The acronym for the deployment location."
  validation {
    condition = (
      contains(["use", "use2", "wus"], var.location_acronym)
    )
    error_message = "Valid values for var: location_acronym are eus (Eastern United States), eus2 (Eastern United States 2), wus (Western Unitied States)."
  }
}

variable "workload_acronym" {
  type        = string
  description = "The acronym for the workload."
  validation {
    condition = (
      length(var.workload_acronym) <= 8
    )
    error_message = "The length of var: workload_acronym must be 8 characters or less."
  }
}

variable "environment_acronym" {
  default     = "d"
  type        = string
  description = "The acronym for the deployment environment."
  validation {
    condition = (
      contains(["d", "q", "u", "s", "p"], var.environment_acronym)
    )
    error_message = "Valid values for var: environment_acronym are s (sandbox), d (development), t (test), q (qa), u (uat), s (staging), p (production)."
  }
}