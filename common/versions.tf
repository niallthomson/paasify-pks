variable "ops_manager_versions" {
  default = {
    1.6 = {
      version = "2.8.2"
      build   = "203"
    }
  }
}

variable "tile_versions" {
  default = {
    1.6 = {
      pks         = "1.6.1"
      harbor      = "1.10.1"
    }
  }
}