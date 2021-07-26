variable "apic_url" {}
variable "apic_username" {}
variable "apic_password" {}

variable "aci_tenant_name" {}
variable "application_name" {}
variable "aci_vrf_name" {}

variable "aci_vds_name" {}

variable "bridge_domains" {
  type = map
  default = {
    example_bd_web = {
      name             = "example_bd_web"
      description      = "Example description"
      arp_flood        = "no"
      ip_learning      = "yes"
      unicast_route    = "yes"
      subnet           = "10.1.10.1/24"
      subnet_scope     = ["private"]
    },
    example_bd_app = {
      name             = "example_bd_app"
      description      = "Example description"
      arp_flood        = "no"
      ip_learning      = "yes"
      unicast_route    = "yes"
      subnet           = "10.1.20.1/24"
      subnet_scope     = ["private"]
    },
  }
}

variable "end_point_groups" {
  type = map
  default = {
      example_epg_web = {
          name = "epg_web",
          bd   = "example_bd_web"

      },
      example_epg_app = {
          name = "epg_app",
          bd   = "example_bd_app"
      }
  }
}
