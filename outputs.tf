output "instance_id" {
  description = "Compute instance ID"
  value       = yandex_compute_instance.this.id
}

output "instance_private_ip" {
  description = "Compute instance private IP"
  value       = yandex_compute_instance.this.network_interface[0].ip_address
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

output "instance_fqdn" {
  description = "Compute instance FQDN"
  value       = yandex_compute_instance.this.fqdn
}

output "instance_status" {
  description = "Compute instance status"
  value       = yandex_compute_instance.this.status
}

output "instance_created_at" {
  description = "Compute instance creation timestamp"
  value       = yandex_compute_instance.this.created_at
}

output "gpu_cluster_id" {
  description = "GPU cluster ID if instance is part of it"
  value       = var.gpu_cluster_id
}

output "filesystems" {
  description = "Attached filesystems data"
  value       = var.filesystems
}

output "dns_records" {
  description = "Configured DNS records"
  value       = var.dns_records
}

output "metadata_options" {
  description = "Configured metadata options"
  value       = var.metadata_options
}
