resource "yandex_compute_disk" "this" {
  for_each = {
    for k, v in var.secondary_disks : k => v if v["enabled"]
  }

  folder_id  = var.folder_id
  zone       = var.zone
  name       = format("%s-%s", var.name, each.key)
  type       = each.value.type
  size       = each.value.size
  block_size = each.value.block_size
  labels     = each.value.labels
}
