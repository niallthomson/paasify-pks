variable "ops_manager_versions" {
  default = {
    1.6 = {
      version = "2.8.2"
      build   = "203"
    }

    1.7 = {
      version = "2.8.5"
      build   = "234"
    }
  }
}

variable "tile_versions" {
  default = {
    1.6 = {
      pks    = "1.6.1"
      harbor = "1.10.1"
    }

    1.7 = {
      pks    = "1.7.0"
      harbor = "1.10.1"
    }
  }
}