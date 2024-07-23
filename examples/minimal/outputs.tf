output "instance_private_ip" {
  value = module.yandex_compute_instance.instance_private_ip
}

output "instance_public_ip" {
  value = module.yandex_compute_instance.instance_public_ip
}
