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
}

variable "enable_ipv4" {
  description = "Allocate an IPv4 address for the interface"
  type        = string
  default     = true
}

variable "private_ip_address" {
  description = "Private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet"
  type        = string
  default     = null
}

variable "enable_ipv6" {
  description = "Allocate an IPv6 address for the interface"
  type        = string
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
}

variable "cores" {
  description = "Cores allocated to the instance"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory allocated to the instance (in Gb)"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Core fraction applied to the instance"
  type        = number
  default     = null
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
  type        = string
  default     = true
}

variable "ssh_user" {
  description = "Initial SSH username for instance"
  type        = string
  default     = "ubuntu"
}

variable "ssh_pubkey" {
  description = "Public RSA key path to inject"
  type        = string
  default     = null
}

variable "enable_oslogin" {
  description = "Enable OS Login"
  type        = string
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
}
