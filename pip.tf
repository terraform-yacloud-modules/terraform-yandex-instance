resource "yandex_vpc_address" "main" {
  for_each = {
    for idx, ni in var.network_interfaces :
    idx => ni
    if lookup(ni, "nat", false) && lookup(ni, "nat_ip_address", null) == null
  }

  name                = format("%s-%s", var.name, each.key)
  description         = try(each.value.pip.description, null)
  folder_id           = var.folder_id
  labels              = var.labels
  deletion_protection = try(each.value.pip.deletion_protection, null)

  external_ipv4_address {
    zone_id                  = try(each.value.pip.ddos_protection_provider, var.zone, null)
    ddos_protection_provider = try(each.value.pip.ddos_protection_provider, null)
    outgoing_smtp_capability = try(each.value.pip.outgoing_smtp_capability, null)
  }

  dynamic "dns_record" {
    for_each = try(each.value.pip.dns_record, null) != null ? [each.value.pip.dns_record] : []
    content {
      fqdn        = dns_record.value.fqdn
      dns_zone_id = dns_record.value.dns_zone_id
      ttl         = lookup(dns_record.value, "ttl", null)
      ptr         = lookup(dns_record.value, "ptr", false)
    }
  }
}
