variable "case" {
  default     = "kabab"
  type        = string
  description = "Allows users to specify the desired case."
  validation {
    condition = (
      contains(["kabab", "snake", "camel", "lower"], var.case)
    )
    error_message = "Valid values for var: case are kabab (this-resource), snake (this_resource), camel (thisResource), lower (thisresource)."
  }
}

variable "location_acronym" {
  default     = "use"
  type        = string
  description = "The acronym for the deployment location."
  validation {
    condition = (
      contains(["a", "ap", "as", "asc", "asc2", "ase", "ass", "b", "bs", "bse", "c", "cc", "ce", "ci", "cus", "cuse", "ea", "eus", "eus2", "eus2e", "e", "f", "fc", "fs", "ger", "gn", "gwc", "glob", "i", "j", "je", "jw", "jic", "jiw", "k", "kc", "ks", "ncus", "ne", "n", "nwe", "nw", "sa", "san", "saw", "scus", "si", "sea", "sc", "s", "sn", "sw", "uc", "un", "uks", "ukw", "uae", "uk", "us", "wcus", "we", "wi", "wus", "wus2", "wus3"], var.location_acronym)
    )
    error_message = "Valid values for var: location_acronym are ea (Asia), ap (Asia Pacific), as (Australia), asc (Australia Central), asc2 (Australia Central 2), ase (Australia East), ass (Australia Southeast), b (Brazil), bs (Brazil South), bse (Brazil Southeas), c (Canada), cc (Canada Central), ce (Canada East), ci (Central India), cus (Central US), cuse (Central US EUAP), ea (East Asia), eus (East US), eus2 (East US 2), eus2e (East US 2 EUAP), e (Europe), f (France), fc (France Central), fs (France South), ger (Germany), gn (Germany North), gwc (Germany West Central), glob (Global), i (India), j (Japan), je (Japan East), jw (Japan West), jic (Jio India Central), jiw (Jio India West), k (Korea), kc (Korea Central), ks (Korea South), ncus (North Central US), ne (North Europe), n (Norway), nwe (Norway East), nw (Norway West), sa (South Africa), san (South Africa North), saw (South Africa West), scus (South Central US), si (South India), sea (Southeast Asia), sc (Sweden Central), s (Switzerland), sn (Switzerland North), sw (Switzerland West), uc (UAE Central), un (UAE North), uks (UK South), ukw (UK West), uae (United Arab Emirates), uk (United Kingdom), us (United States), wcus (West Central US), we (West Europe), wi (West India), wus (West US), wus2 (West US 2), wus3 (West US 3)."
  }
}

variable "workload_acronym" {
  type        = string
  description = "The acronym for the workload.  This might be an application, project, focus area, or other item."
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
  description = "The acronym for the deployment environment.  For example, 'd' for 'development'."
  validation {
    condition = (
      contains(["x", "d", "t", "q", "u", "s", "p"], var.environment_acronym)
    )
    error_message = "Valid values for var: environment_acronym are x (Sandbox), d (Development), t (Test), q (QA), u (UAT), s (Staging), p (Production)."
  }
}