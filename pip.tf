resource "yandex_vpc_address" "main" {
  count = var.create_pip ? 1 : 0

  name = var.name

  external_ipv4_address {
    zone_id = var.zone
  }
}
