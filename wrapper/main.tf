module "wrapper" {
  source = "../"

  for_each = var.items

}
