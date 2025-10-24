module "wrapper" {
  source = "../"

  for_each = var.items

  # Naming
  name        = try(each.value.name, var.defaults.name, null)
  folder_id   = try(each.value.folder_id, var.defaults.folder_id, null)
  description = try(each.value.description, var.defaults.description, null)
  labels      = try(each.value.labels, var.defaults.labels, {})

  # Network
  zone                      = try(each.value.zone, var.defaults.zone, null)
  subnet_id                 = try(each.value.subnet_id, var.defaults.subnet_id, "")
  enable_nat                = try(each.value.enable_nat, var.defaults.enable_nat, null)
  create_pip                = try(each.value.create_pip, var.defaults.create_pip, true)
  public_ip_address         = try(each.value.public_ip_address, var.defaults.public_ip_address, null)
  enable_ipv4               = try(each.value.enable_ipv4, var.defaults.enable_ipv4, null)
  private_ip_address        = try(each.value.private_ip_address, var.defaults.private_ip_address, null)
  enable_ipv6               = try(each.value.enable_ipv6, var.defaults.enable_ipv6, false)
  private_ipv6_address      = try(each.value.private_ipv6_address, var.defaults.private_ipv6_address, null)
  security_group_ids        = try(each.value.security_group_ids, var.defaults.security_group_ids, [])
  network_acceleration_type = try(each.value.network_acceleration_type, var.defaults.network_acceleration_type, "standard")
  serial_port_enable        = try(each.value.serial_port_enable, var.defaults.serial_port_enable, false)
  docker_compose            = try(each.value.docker_compose, var.defaults.docker_compose, null)

  # VM size
  platform_id   = try(each.value.platform_id, var.defaults.platform_id, "standard-v3")
  cores         = try(each.value.cores, var.defaults.cores, 2)
  memory        = try(each.value.memory, var.defaults.memory, 2)
  core_fraction = try(each.value.core_fraction, var.defaults.core_fraction, 100)

  # Scheduling
  preemptible              = try(each.value.preemptible, var.defaults.preemptible, false)
  placement_group_id       = try(each.value.placement_group_id, var.defaults.placement_group_id, null)
  placement_affinity_rules = try(each.value.placement_affinity_rules, var.defaults.placement_affinity_rules, [])

  # VM image
  image_snapshot_id = try(each.value.image_snapshot_id, var.defaults.image_snapshot_id, null)
  image_id          = try(each.value.image_id, var.defaults.image_id, null)
  image_family      = try(each.value.image_family, var.defaults.image_family, "ubuntu-2004-lts")

  # VM options
  hostname                  = try(each.value.hostname, var.defaults.hostname, null)
  maintenance_grace_period  = try(each.value.maintenance_grace_period, var.defaults.maintenance_grace_period, null)
  maintenance_policy        = try(each.value.maintenance_policy, var.defaults.maintenance_policy, null)
  service_account_id        = try(each.value.service_account_id, var.defaults.service_account_id, null)
  allow_stopping_for_update = try(each.value.allow_stopping_for_update, var.defaults.allow_stopping_for_update, true)
  generate_ssh_key          = try(each.value.generate_ssh_key, var.defaults.generate_ssh_key, true)
  ssh_user                  = try(each.value.ssh_user, var.defaults.ssh_user, "ubuntu")
  ssh_pubkey                = try(each.value.ssh_pubkey, var.defaults.ssh_pubkey, null)
  enable_oslogin            = try(each.value.enable_oslogin, var.defaults.enable_oslogin, false)
  user_data                 = try(each.value.user_data, var.defaults.user_data, null)

  # VM disks
  boot_disk                   = try(each.value.boot_disk, var.defaults.boot_disk, {})
  boot_disk_name              = try(each.value.boot_disk_name, var.defaults.boot_disk_name, null)
  boot_disk_description       = try(each.value.boot_disk_description, var.defaults.boot_disk_description, null)
  boot_disk_initialize_params = try(each.value.boot_disk_initialize_params, var.defaults.boot_disk_initialize_params, {})
  boot_disk_kms_key_id        = try(each.value.boot_disk_kms_key_id, var.defaults.boot_disk_kms_key_id, null)
  secondary_disks             = try(each.value.secondary_disks, var.defaults.secondary_disks, {})
  secondary_disks_kms_key_ids = try(each.value.secondary_disks_kms_key_ids, var.defaults.secondary_disks_kms_key_ids, {})
  timeouts                    = try(each.value.timeouts, var.defaults.timeouts, null)

  # Filesystems
  filesystems = try(each.value.filesystems, var.defaults.filesystems, {})

  # DNS records
  dns_records      = try(each.value.dns_records, var.defaults.dns_records, [])
  ipv6_dns_records = try(each.value.ipv6_dns_records, var.defaults.ipv6_dns_records, [])
  nat_dns_records  = try(each.value.nat_dns_records, var.defaults.nat_dns_records, [])

  # GPU configuration
  gpus           = try(each.value.gpus, var.defaults.gpus, 0)
  gpu_cluster_id = try(each.value.gpu_cluster_id, var.defaults.gpu_cluster_id, null)

  # Metadata options
  metadata_options = try(each.value.metadata_options, var.defaults.metadata_options, null)
}
