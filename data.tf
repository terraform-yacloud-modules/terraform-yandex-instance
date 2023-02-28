data "yandex_client_config" "client" {}

data "yandex_compute_image" "this" {
  family = var.image_family
}
