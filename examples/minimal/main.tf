module "yandex_compute_instance" {
  source = "../"

  folder_id = "xxxx"

  name = "my-instance"

  zone       = "ru-central1-a"
  subnet_id  = "xxxx"
  enable_nat = true
  create_pip = true

  hostname         = "my-instance"
  generate_ssh_key = false
  ssh_user         = "ubuntu"
  ssh_pubkey       = "~/.ssh/id_rsa.pub"

}
