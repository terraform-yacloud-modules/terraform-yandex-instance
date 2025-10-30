#
# yandex cloud coordinates
#
variable "folder_id" {
  description = "Folder ID"
  type        = string
  default     = null
}

#
# naming
#
variable "name" {
  description = "Name which will be used for all resources"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 63
    error_message = "Name must be between 1 and 63 characters long."
  }

  validation {
    condition     = can(regex("^[a-z]([-a-z0-9]*[a-z0-9])?$", var.name))
    error_message = "Name must start with a lowercase letter and can only contain lowercase letters, numbers, and hyphens."
  }
}

variable "description" {
  description = "Instance description"
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of labels which will be applied to all resources"
  type        = map(string)
  default     = {}
}

#
# network
#
variable "zone" {
  description = "Network zone"
  type        = string
  default     = null

}

variable "subnet_id" {
  description = "VPC Subnet ID"
  type        = string
}

variable "enable_nat" {
  description = "Enable public IPv4 address"
  type        = bool
  default     = null
}

variable "create_pip" {
  description = "Create public IP address for instance; If true public_ip_address will be ignored"
  type        = bool
  default     = true
}

variable "public_ip_address" {
  description = "Public IP address to assign to the instance"
  type        = string
  default     = null

  validation {
    condition     = var.public_ip_address == null || can(cidrhost("${var.public_ip_address}/32", 0))
    error_message = "Public IP address must be a valid IPv4 address or null."
  }
}

variable "enable_ipv4" {
  description = "Allocate an IPv4 address for the interface"
  type        = bool
  default     = true
}

variable "private_ip_address" {
  description = "Private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet"
  type        = string
  default     = null

  validation {
    condition     = var.private_ip_address == null || can(cidrhost("${var.private_ip_address}/32", 0))
    error_message = "Private IP address must be a valid IPv4 address or null."
  }
}

variable "enable_ipv6" {
  description = "Allocate an IPv6 address for the interface"
  type        = bool
  default     = false
}

variable "private_ipv6_address" {
  description = "Private IPv6 address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs linked to the instance"
  type        = list(string)
  default     = null
}

variable "network_acceleration_type" {
  description = "Network acceleration type"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "software-accelerated"], var.network_acceleration_type)
    error_message = "Network acceleration type must be 'standard' or 'software-accelerated'."
  }
}

variable "serial_port_enable" {
  description = "Enable serial port on the instance"
  type        = bool
  default     = false
}

variable "docker_compose" {
  description = "The key in the VM metadata that uses the docker-compose specification"
  type        = string
  default     = null
}

#
# vm size
#
variable "platform_id" {
  description = "Hardware CPU platform name (Intel Ice Lake by default)"
  type        = string
  default     = "standard-v3"

  validation {
    condition     = contains(["standard-v1", "standard-v2", "standard-v3", "gpu-standard-v1"], var.platform_id)
    error_message = "Platform ID must be one of: standard-v1, standard-v2, standard-v3, gpu-standard-v1."
  }
}

variable "cores" {
  description = "Cores allocated to the instance"
  type        = number
  default     = 2

  validation {
    condition     = var.cores > 0 && var.cores <= 80
    error_message = "Cores must be between 1 and 80."
  }
}

variable "memory" {
  description = "Memory allocated to the instance (in Gb)"
  type        = number
  default     = 2

  validation {
    condition     = var.memory >= 1 && var.memory <= 640 && floor(var.memory) == var.memory
    error_message = "Memory must be an integer between 1 and 640 GB."
  }
}

variable "core_fraction" {
  description = "Core fraction applied to the instance"
  type        = number
  default     = null

  validation {
    condition     = var.core_fraction == null || (var.core_fraction >= 0 && var.core_fraction <= 100)
    error_message = "Core fraction must be between 0 and 100 or null."
  }
}

#
# scheduling
#
variable "preemptible" {
  description = "Make instance preemptible"
  type        = bool
  default     = false
}

variable "placement_group_id" {
  description = "Placement group ID"
  type        = string
  default     = ""
}

variable "placement_affinity_rules" {
  description = "List of host affinity rules"
  type = list(object({
    key   = string
    op    = string
    value = list(string)
  }))
  default = []
}

#
# vm image
#
variable "image_snapshot_id" {
  description = <<-EOT
Image snapshot id to initialize from.
Highest priority over var.image_id
and var.image_family"
EOT
  type        = string
  default     = null
}

variable "image_id" {
  description = "Image ID (medium priority)"
  type        = string
  default     = null
}

variable "image_family" {
  description = "Default image family name (lowest priority)"
  type        = string
  default     = "ubuntu-2004-lts"
}

#
# vm options
#
variable "hostname" {
  description = "Hostname of the instance. More info: https://cloud.yandex.ru/docs/compute/concepts/network#hostname"
  type        = string
  default     = null
}

variable "maintenance_grace_period" {
  description = "Time between notification via metadata service and maintenance. Can be: 60s. The default is null."
  type        = string
  default     = null
}

variable "maintenance_policy" {
  description = "Behavior on maintenance events. Can be: unspecified, migrate, restart. The default is null."
  type        = string
  default     = null
}

variable "service_account_id" {
  description = "ID of the service account authorized for instance"
  type        = string
  default     = null
}

variable "allow_stopping_for_update" {
  description = "Allow stop the instance in order to update properties"
  type        = bool
  default     = true
}

variable "generate_ssh_key" {
  description = "If true, SSH key will be generated for instance group"
  type        = bool
  default     = true
}

variable "ssh_user" {
  description = "Initial SSH username for instance"
  type        = string
  default     = "ubuntu"

  validation {
    condition     = length(var.ssh_user) > 0 && length(var.ssh_user) <= 32
    error_message = "SSH user must be between 1 and 32 characters long."
  }

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]*$", var.ssh_user))
    error_message = "SSH user must start with a letter or underscore and contain only letters, numbers, hyphens, and underscores."
  }
}

variable "ssh_pubkey" {
  description = "Public RSA key path to inject"
  type        = string
  default     = null
}

variable "enable_oslogin" {
  description = "Enable OS Login"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Cloud-init user-data"
  type        = string
  default     = null
}

#
# vm disks
#
variable "boot_disk" {
  description = "Basic boot disk parameters"
  type = object({
    auto_delete = optional(bool)
    device_name = optional(string)
    mode        = optional(string)
    disk_id     = optional(string, null)
  })
  default = {}
}

variable "boot_disk_initialize_params" {
  description = "Additional boot disk parameters"
  type = object({
    size       = optional(number, 10)
    block_size = optional(number, 4096)
    type       = optional(string, "network-hdd")
  })
  default = {}

  validation {
    condition = var.boot_disk_initialize_params.size == null || (
      var.boot_disk_initialize_params.size >= 1 && var.boot_disk_initialize_params.size <= 4096
    )
    error_message = "Boot disk size must be between 1 and 4096 GB."
  }

  validation {
    condition = var.boot_disk_initialize_params.block_size == null || (
      contains([4096, 8192], var.boot_disk_initialize_params.block_size)
    )
    error_message = "Boot disk block size must be 4096 or 8192 bytes."
  }

  validation {
    condition = var.boot_disk_initialize_params.type == null || (
      contains(["network-hdd", "network-ssd", "network-ssd-nonreplicated", "local-ssd"], var.boot_disk_initialize_params.type)
    )
    error_message = "Boot disk type must be one of: network-hdd, network-ssd, network-ssd-nonreplicated, local-ssd."
  }
}

variable "secondary_disks" {
  description = "Additional disks with params"
  type = map(object({
    enabled     = optional(bool, true)
    auto_delete = optional(bool, false)
    mode        = optional(string)
    labels      = optional(map(string), {})
    type        = optional(string, "network-hdd")
    size        = optional(number, 10)
    block_size  = optional(number, 4096)
    device_name = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for disk_name, disk in var.secondary_disks : (
        (disk.size == null || (disk.size >= 1 && disk.size <= 4096)) &&
        (disk.block_size == null || contains([4096, 8192], disk.block_size)) &&
        (disk.type == null || contains(["network-hdd", "network-ssd", "network-ssd-nonreplicated", "local-ssd"], disk.type)) &&
        (disk.mode == null || contains(["READ_ONLY", "READ_WRITE"], disk.mode))
      )
    ])
    error_message = "Secondary disks must have valid parameters: size 1-4096 GB, block size 4096 or 8192 bytes, valid disk type, and valid mode."
  }
}

variable "timeouts" {
  description = "Timeout settings for cluster operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

#
# DNS records
#
variable "dns_records" {
  description = "DNS records for IPv4 addresses"
  type = list(object({
    fqdn        = string
    dns_zone_id = optional(string)
    ttl         = optional(number)
    ptr         = optional(bool)
  }))
  default = []
}

variable "ipv6_dns_records" {
  description = "DNS records for IPv6 addresses"
  type = list(object({
    fqdn        = string
    dns_zone_id = optional(string)
    ttl         = optional(number)
    ptr         = optional(bool)
  }))
  default = []
}

variable "nat_dns_records" {
  description = "DNS records for NAT IPv4 addresses"
  type = list(object({
    fqdn        = string
    dns_zone_id = optional(string)
    ttl         = optional(number)
    ptr         = optional(bool)
  }))
  default = []
}

#
# KMS encryption
#
variable "boot_disk_kms_key_id" {
  description = "ID of KMS symmetric key used to encrypt boot disk"
  type        = string
  default     = null
}

variable "secondary_disks_kms_key_ids" {
  description = "Map of KMS key IDs for secondary disks encryption"
  type        = map(string)
  default     = {}
}

#
# GPU configuration
#
variable "gpus" {
  description = "Number of GPU cores allocated for the instance"
  type        = number
  default     = 0

  validation {
    condition     = var.gpus >= 0 && var.gpus <= 8
    error_message = "GPUs must be between 0 and 8."
  }
}

variable "gpu_cluster_id" {
  description = "ID of GPU cluster if instance is part of it"
  type        = string
  default     = null
}


#
# Metadata options
#
variable "metadata_options" {
  description = "Options to configure access to instance's metadata"
  type = object({
    gce_http_endpoint    = optional(string)
    aws_v1_http_endpoint = optional(string)
    gce_http_token       = optional(string)
    aws_v1_http_token    = optional(string)
  })
  default = null
}


#
# Additional boot disk parameters
#
variable "boot_disk_name" {
  description = "Name of the boot disk"
  type        = string
  default     = null
}

variable "boot_disk_description" {
  description = "Description of the boot disk"
  type        = string
  default     = null
}

#
# Filesystem attachments
#
variable "filesystems" {
  description = "Filesystems to attach to the instance"
  type = map(object({
    filesystem_id = string
    device_name   = optional(string)
    mode          = optional(string)
  }))
  default = {}
}
