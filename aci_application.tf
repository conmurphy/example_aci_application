data "aci_tenant" "aci_tenant" {
  name             = var.aci_tenant_name
}

resource "aci_vrf" "aci_vrf" {
  tenant_dn         = data.aci_tenant.aci_tenant.id
  name              = var.aci_vrf_name
}

resource "aci_bridge_domain" "aci_bridge_domain" {
    for_each = var.bridge_domains
    tenant_dn             = data.aci_tenant.aci_tenant.id
    relation_fv_rs_ctx    = aci_vrf.aci_vrf.id
    name                  = each.value.name
    arp_flood             = each.value.arp_flood
    ip_learning           = each.value.ip_learning
    unicast_route         = each.value.unicast_route
}

resource "aci_subnet" "aci_subnet" {
    for_each             = var.bridge_domains
    parent_dn            = aci_bridge_domain.aci_bridge_domain[each.key].id
    ip                   = each.value.subnet
    scope                = each.value.subnet_scope
}

resource "aci_application_profile" "aci_application_profile" {
  tenant_dn         = data.aci_tenant.aci_tenant.id
  name              = var.application_name
}


resource "aci_application_epg" "aci_application_epg" {
  for_each = var.end_point_groups

  application_profile_dn  = aci_application_profile.aci_application_profile.id
  name                    = each.value.name
  relation_fv_rs_bd       = aci_bridge_domain.aci_bridge_domain[each.value.bd].id
  relation_fv_rs_cons     = [aci_contract.aci_contract.id]
  relation_fv_rs_prov     = [aci_contract.aci_contract.id]
}

resource "aci_contract" "aci_contract" {
  tenant_dn   = data.aci_tenant.aci_tenant.id
  name        = var.application_name
 }

 resource "aci_contract_subject" "aci_contract_subject" {
   contract_dn                  = aci_contract.aci_contract.id
   name                         = var.application_name
   relation_vz_rs_subj_filt_att = [aci_filter.allow_icmp.id]
 }

 resource "aci_filter" "allow_icmp" {
   tenant_dn = data.aci_tenant.aci_tenant.id
   name      = "allow_icmp"
 }

 resource "aci_filter_entry" "icmp" {
   name        = "icmp"
   filter_dn   = aci_filter.allow_icmp.id
   ether_t     = "ip"
   prot        = "icmp"
   stateful    = "yes"
 }

 data "aci_vmm_domain" "aci_vmm_domain" {
  provider_profile_dn     = "/uni/vmmp-VMware"
  name                     = var.aci_vds_name
}

resource "aci_epg_to_domain" "aci_epg_to_domain" {
    for_each = var.end_point_groups

    application_epg_dn = aci_application_epg.aci_application_epg[each.key].id
    tdn = data.aci_vmm_domain.aci_vmm_domain.id
}
