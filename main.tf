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

  maintenance_grace_period  = var.maintenance_grace_period
  maintenance_policy        = var.maintenance_policy
  service_account_id        = var.service_account_id
  allow_stopping_for_update = var.allow_stopping_for_update

  metadata = {
    docker-compose     = var.docker_compose == null ? null : file(var.docker_compose)
    serial-port-enable = var.serial_port_enable ? 1 : null
    ssh-keys           = local.ssh_keys
    enable-oslogin     = var.enable_oslogin
    user-data          = var.user_data
  }
  metadata_options {
    gce_http_endpoint    = var.metadata_options != null ? try(var.metadata_options.gce_http_endpoint, null) : null
    aws_v1_http_endpoint = var.metadata_options != null ? try(var.metadata_options.aws_v1_http_endpoint, null) : null
    gce_http_token       = var.metadata_options != null ? try(var.metadata_options.gce_http_token, null) : null
    aws_v1_http_token    = var.metadata_options != null ? try(var.metadata_options.aws_v1_http_token, null) : null
  }

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

  gpu_cluster_id = var.gpu_cluster_id

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
    gpus          = var.gpus > 0 ? var.gpus : null
  }

  boot_disk {
    auto_delete = var.boot_disk.auto_delete
    device_name = var.boot_disk.device_name
    mode        = var.boot_disk.mode
    disk_id     = var.boot_disk.disk_id

    initialize_params {
      name        = coalesce(var.boot_disk_name, format("%s-boot-disk", var.name))
      description = var.boot_disk_description
      size        = var.boot_disk_initialize_params.size
      block_size  = var.boot_disk_initialize_params.block_size
      type        = var.boot_disk_initialize_params.type
      image_id    = local.use_snapshot ? null : local.image_id
      snapshot_id = local.use_snapshot ? var.image_snapshot_id : null
      kms_key_id  = var.boot_disk_kms_key_id
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

  dynamic "filesystem" {
    for_each = var.filesystems
    content {
      filesystem_id = filesystem.value.filesystem_id
      device_name   = filesystem.value.device_name
      mode          = filesystem.value.mode
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

    dynamic "dns_record" {
      for_each = var.dns_records
      content {
        fqdn        = dns_record.value.fqdn
        dns_zone_id = dns_record.value.dns_zone_id
        ttl         = dns_record.value.ttl
        ptr         = dns_record.value.ptr
      }
    }

    dynamic "ipv6_dns_record" {
      for_each = var.ipv6_dns_records
      content {
        fqdn        = ipv6_dns_record.value.fqdn
        dns_zone_id = ipv6_dns_record.value.dns_zone_id
        ttl         = ipv6_dns_record.value.ttl
        ptr         = ipv6_dns_record.value.ptr
      }
    }

    dynamic "nat_dns_record" {
      for_each = var.nat_dns_records
      content {
        fqdn        = nat_dns_record.value.fqdn
        dns_zone_id = nat_dns_record.value.dns_zone_id
        ttl         = nat_dns_record.value.ttl
        ptr         = nat_dns_record.value.ptr
      }
    }
  }


  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

}
