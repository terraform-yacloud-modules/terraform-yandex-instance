data "yandex_client_config" "client" {}

module "network" {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-vpc.git?ref=v1.0.0"

  folder_id = data.yandex_client_config.client.folder_id

  blank_name = "instance-vpc-nat-gateway"
  labels = {
    repo = "terraform-yacloud-modules/terraform-yandex-vpc"
  }

  azs = ["ru-central1-a"]

  private_subnets = [["10.1.10.0/24"]]

  create_vpc         = true
  create_nat_gateway = true
}

module "yandex_compute_instance" {
  source = "../../"

  folder_id = data.yandex_client_config.client.folder_id

  name         = "my-instance"
  description  = "Test instance"
  image_family = "ubuntu-2204-lts"
  labels = {
    environment = "dev"
    project     = "example"
  }

  zone                      = "ru-central1-a"
  subnet_id                 = module.network.private_subnets_ids[0]
  enable_nat                = true
  create_pip                = true
  network_acceleration_type = "standard"
  serial_port_enable        = false

  platform_id   = "standard-v3"
  cores         = 2
  memory        = 4
  core_fraction = 100

  preemptible = false

  hostname                  = "my-instance"
  allow_stopping_for_update = true
  generate_ssh_key          = false
  ssh_user                  = "ubuntu"
  ssh_pubkey                = "~/.ssh/id_rsa.pub"

  enable_oslogin = false

  user_data = <<-EOF
#cloud-config
packages:
  - nginx
  - htop
  - curl
  - wget

runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - echo "Сервер успешно настроен" > /var/log/setup.log

write_files:
  - path: /etc/nginx/sites-available/default
    content: |
      server {
          listen 80 default_server;
          listen [::]:80 default_server;

          root /var/www/html;
          index index.html index.htm index.nginx-debian.html;

          server_name _;

          location / {
              try_files $uri $uri/ =404;
          }
      }
EOF

  boot_disk = {
    auto_delete = true
    device_name = "boot-disk"
    mode        = "READ_WRITE"
  }

  boot_disk_initialize_params = {
    size       = 20
    block_size = 4096
    type       = "network-ssd"
  }

  secondary_disks = {
    "data" = {
      enabled     = true
      auto_delete = false
      mode        = "READ_WRITE"
      type        = "network-hdd"
      size        = 100
      block_size  = 4096
      device_name = "data-disk"
      labels = {
        purpose = "application-data"
      }
    }
  }

}
