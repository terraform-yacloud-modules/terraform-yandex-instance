output "instance_id" {
  description = "Compute instance ID"
  value       = yandex_compute_instance.this.id
}

output "instance_private_ip" {
  description = "Compute instance private IP"
  value       = yandex_compute_instance.this.network_interface.0.ip_address
}

output "instance_public_ip" {
  description = "Compute instance public IP"
  value       = local.instance_public_ip
}

output "compute_disks" {
  description = "Secondary disk's data"
  value = (
    {
      for name, value in var.secondary_disks :
      name => merge(
        { "device_name" = value.device_name },
        yandex_compute_disk.this[name]
      )
    }
  )
}

output "ssh_key_pub" {
  description = "Public SSH key"
  sensitive   = true
  value       = var.generate_ssh_key ? tls_private_key.this[0].public_key_openssh : null
}

output "ssh_key_prv" {
  description = "Private SSH key"
  sensitive   = true
  value       = var.generate_ssh_key ? tls_private_key.this[0].private_key_pem : null
}
