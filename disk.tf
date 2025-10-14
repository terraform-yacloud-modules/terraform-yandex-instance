resource "yandex_compute_disk" "this" {
  for_each = {
    for k, v in var.secondary_disks : k => v if v["enabled"]
  }

  folder_id  = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
  zone       = var.zone
  name       = format("%s-%s", var.name, each.key)
  type       = each.value.type
  size       = each.value.size
  block_size = each.value.block_size
  labels     = each.value.labels

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}
