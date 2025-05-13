locals {
  use_snapshot = var.image_snapshot_id != null ? true : false
  image_id = (
    coalesce(
      var.image_id,
      data.yandex_compute_image.this.id
  ))
  ssh_keys           = var.generate_ssh_key ? "${var.ssh_user}:${tls_private_key.this[0].public_key_openssh}" : (var.ssh_pubkey != null ? "${var.ssh_user}:${file(var.ssh_pubkey)}" : null)
  instance_public_ip = var.create_pip ? yandex_vpc_address.main[0].external_ipv4_address[0].address : var.public_ip_address
}

resource "tls_private_key" "this" {
  count = var.generate_ssh_key ? 1 : 0

  algorithm = "RSA"
}

resource "yandex_compute_instance" "this" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
  labels      = var.labels

  zone     = var.zone
  hostname = var.hostname

  service_account_id        = var.service_account_id
  allow_stopping_for_update = var.allow_stopping_for_update

  metadata = {
    docker-compose     = var.docker_compose == null ? null : file(var.docker_compose)
    serial-port-enable = var.serial_port_enable ? 1 : null
    ssh-keys           = local.ssh_keys
    enable-oslogin     = var.enable_oslogin
    user-data          = var.user_data
  }
  metadata_options {}

  platform_id = var.platform_id
  scheduling_policy {
    preemptible = var.preemptible
  }

  placement_policy {
    placement_group_id = var.placement_group_id

    dynamic "host_affinity_rules" {
      for_each = var.placement_affinity_rules

      content {
        key    = host_affinity_rules.value["key"]
        op     = host_affinity_rules.value["op"]
        values = host_affinity_rules.value["value"]
      }
    }
  }

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    auto_delete = var.boot_disk.auto_delete
    device_name = var.boot_disk.device_name
    mode        = var.boot_disk.mode
    disk_id     = var.boot_disk.disk_id

    initialize_params {
      name        = format("%s-boot-disk", var.name)
      description = ""
      size        = var.boot_disk_initialize_params.size
      block_size  = var.boot_disk_initialize_params.block_size
      type        = var.boot_disk_initialize_params.type
      image_id    = local.use_snapshot ? null : local.image_id
      snapshot_id = local.use_snapshot ? var.image_snapshot_id : null
    }
  }

  dynamic "secondary_disk" {
    for_each = (
      {
        for disk_name, disk_info in yandex_compute_disk.this :
        disk_name => merge(disk_info, var.secondary_disks[disk_name])
      }
    )

    iterator = disk
    content {
      disk_id     = disk.value.id
      auto_delete = disk.value.auto_delete
      device_name = disk.value.device_name
      mode        = disk.value.mode
    }
  }

  network_acceleration_type = var.network_acceleration_type
  network_interface {
    subnet_id          = var.subnet_id
    ipv4               = var.enable_ipv4
    ip_address         = var.private_ip_address
    ipv6               = var.enable_ipv6
    ipv6_address       = var.private_ipv6_address
    nat                = var.enable_nat
    nat_ip_address     = local.instance_public_ip
    security_group_ids = var.security_group_ids
    # dns_record {}
    # ipv6_dns_record{}
    # nat_dns_record {}
  }
}
