# Yandex Cloud VM Instance Terraform module

Terraform module which creates Yandex Cloud Instance resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-instance/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.72.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.1.0 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [yandex_compute_disk.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_disk) | resource |
| [yandex_compute_instance.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [yandex_vpc_address.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_address) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |
| [yandex_compute_image.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_stopping_for_update"></a> [allow\_stopping\_for\_update](#input\_allow\_stopping\_for\_update) | Allow stop the instance in order to update properties | `bool` | `true` | no |
| <a name="input_boot_disk"></a> [boot\_disk](#input\_boot\_disk) | Basic boot disk parameters | <pre>object({<br/>    auto_delete = optional(bool)<br/>    device_name = optional(string)<br/>    mode        = optional(string)<br/>    disk_id     = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_boot_disk_initialize_params"></a> [boot\_disk\_initialize\_params](#input\_boot\_disk\_initialize\_params) | Additional boot disk parameters | <pre>object({<br/>    size       = optional(number, 10)<br/>    block_size = optional(number, 4096)<br/>    type       = optional(string, "network-hdd")<br/>  })</pre> | `{}` | no |
| <a name="input_core_fraction"></a> [core\_fraction](#input\_core\_fraction) | Core fraction applied to the instance | `number` | `null` | no |
| <a name="input_cores"></a> [cores](#input\_cores) | Cores allocated to the instance | `number` | `2` | no |
| <a name="input_create_pip"></a> [create\_pip](#input\_create\_pip) | Create public IP address for instance; If true public\_ip\_address will be ignored | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Instance description | `string` | `null` | no |
| <a name="input_docker_compose"></a> [docker\_compose](#input\_docker\_compose) | The key in the VM metadata that uses the docker-compose specification | `string` | `null` | no |
| <a name="input_enable_ipv4"></a> [enable\_ipv4](#input\_enable\_ipv4) | Allocate an IPv4 address for the interface | `string` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Allocate an IPv6 address for the interface | `string` | `false` | no |
| <a name="input_enable_nat"></a> [enable\_nat](#input\_enable\_nat) | Enable public IPv4 address | `bool` | `null` | no |
| <a name="input_enable_oslogin"></a> [enable\_oslogin](#input\_enable\_oslogin) | Enable OS Login | `string` | `false` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | Folder ID | `string` | `null` | no |
| <a name="input_generate_ssh_key"></a> [generate\_ssh\_key](#input\_generate\_ssh\_key) | If true, SSH key will be generated for instance group | `string` | `true` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname of the instance. More info: https://cloud.yandex.ru/docs/compute/concepts/network#hostname | `string` | `null` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Default image family name (lowest priority) | `string` | `"ubuntu-2004-lts"` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | Image ID (medium priority) | `string` | `null` | no |
| <a name="input_image_snapshot_id"></a> [image\_snapshot\_id](#input\_image\_snapshot\_id) | Image snapshot id to initialize from.<br/>Highest priority over var.image\_id<br/>and var.image\_family" | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A set of labels which will be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_maintenance_grace_period"></a> [maintenance\_grace\_period](#input\_maintenance\_grace\_period) | Time between notification via metadata service and maintenance. Can be: 60s. The default is null. | `any` | `null` | no |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | Behavior on maintenance events. Can be: unspecified, migrate, restart. The default is null. | `any` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory allocated to the instance (in Gb) | `number` | `2` | no |
| <a name="input_name"></a> [name](#input\_name) | Name which will be used for all resources | `string` | n/a | yes |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | Network acceleration type | `string` | `"standard"` | no |
| <a name="input_placement_affinity_rules"></a> [placement\_affinity\_rules](#input\_placement\_affinity\_rules) | List of host affinity rules | <pre>list(object({<br/>    key   = string<br/>    op    = string<br/>    value = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_placement_group_id"></a> [placement\_group\_id](#input\_placement\_group\_id) | Placement group ID | `string` | `""` | no |
| <a name="input_platform_id"></a> [platform\_id](#input\_platform\_id) | Hardware CPU platform name (Intel Ice Lake by default) | `string` | `"standard-v3"` | no |
| <a name="input_preemptible"></a> [preemptible](#input\_preemptible) | Make instance preemptible | `bool` | `false` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | Private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet | `string` | `null` | no |
| <a name="input_private_ipv6_address"></a> [private\_ipv6\_address](#input\_private\_ipv6\_address) | Private IPv6 address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet | `string` | `null` | no |
| <a name="input_public_ip_address"></a> [public\_ip\_address](#input\_public\_ip\_address) | Public IP address to assign to the instance | `string` | `null` | no |
| <a name="input_secondary_disks"></a> [secondary\_disks](#input\_secondary\_disks) | Additional disks with params | <pre>map(object({<br/>    enabled     = optional(bool, true)<br/>    auto_delete = optional(bool, false)<br/>    mode        = optional(string)<br/>    labels      = optional(map(string), {})<br/>    type        = optional(string, "network-hdd")<br/>    size        = optional(number, 10)<br/>    block_size  = optional(number, 4096)<br/>    device_name = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs linked to the instance | `list(string)` | `null` | no |
| <a name="input_serial_port_enable"></a> [serial\_port\_enable](#input\_serial\_port\_enable) | Enable serial port on the instance | `bool` | `false` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | ID of the service account authorized for instance | `string` | `null` | no |
| <a name="input_ssh_pubkey"></a> [ssh\_pubkey](#input\_ssh\_pubkey) | Public RSA key path to inject | `string` | `null` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | Initial SSH username for instance | `string` | `"ubuntu"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Cloud-init user-data | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Network zone | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compute_disks"></a> [compute\_disks](#output\_compute\_disks) | Secondary disk's data |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | Compute instance ID |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | Compute instance private IP |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | Compute instance public IP |
| <a name="output_ssh_key_prv"></a> [ssh\_key\_prv](#output\_ssh\_key\_prv) | Private SSH key |
| <a name="output_ssh_key_pub"></a> [ssh\_key\_pub](#output\_ssh\_key\_pub) | Public SSH key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-instance/blob/main/LICENSE).
