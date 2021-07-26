terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
    }
  }
  required_version = ">= 1.0.1"
}


#configure provider with your cisco aci credentials or update with certificates
provider "aci" {
  username = "${var.apic_username}"
  password = "${var.apic_password}"
  url      = "${var.apic_url}"
  insecure = true
}
