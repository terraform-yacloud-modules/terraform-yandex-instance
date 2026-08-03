# Upgrade from v1.x to v2.x

## Overview

Version 2.0 introduces a breaking change to network interface configuration. The module now uses a dynamic `network_interfaces` variable instead of individual network-related variables, enabling support for multiple network interfaces per instance.

## Breaking Changes

### Network Configuration

The following variables have been **removed**:

- `subnet_id`
- `enable_nat`
- `create_pip`
- `public_ip_address`
- `enable_ipv4`
- `private_ip_address`
- `enable_ipv6`
- `private_ipv6_address`
- `security_group_ids`
- `dns_records`
- `ipv6_dns_records`
- `nat_dns_records`

These are replaced by a single `network_interfaces` list variable.

### Public IP Resource

The `yandex_vpc_address.main` resource now uses `for_each` instead of `count`, creating public IPs per network interface when needed.

## Migration Guide

### Single Network Interface (Most Common)

**Before (v1.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name      = "my-instance"
  subnet_id = "e9b12345678901234"
  
  enable_ipv4        = true
  private_ip_address = "10.0.1.10"
  enable_nat         = true
  create_pip         = true
  
  security_group_ids = ["enp12345678901234"]
  
  dns_records = [
    {
      fqdn        = "my-instance.example.com"
      dns_zone_id = "dns12345678901234"
      ttl         = 300
      ptr         = true
    }
  ]
}
```

**After (v2.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name = "my-instance"
  
  network_interfaces = [
    {
      subnet_id      = "e9b12345678901234"
      ipv4           = true
      ip_address     = "10.0.1.10"
      nat            = true
      
      security_group_ids = ["enp12345678901234"]
      
      dns_record = [
        {
          fqdn        = "my-instance.example.com"
          dns_zone_id = "dns12345678901234"
          ttl         = 300
          ptr         = true
        }
      ]
    }
  ]
}
```

### With Custom Public IP

**Before (v1.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name              = "my-instance"
  subnet_id         = "e9b12345678901234"
  enable_nat        = true
  create_pip        = false
  public_ip_address = "203.0.113.10"
}
```

**After (v2.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name = "my-instance"
  
  network_interfaces = [
    {
      subnet_id      = "e9b12345678901234"
      nat            = true
      nat_ip_address = "203.0.113.10"
    }
  ]
}
```

### With IPv6

**Before (v1.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name                 = "my-instance"
  subnet_id            = "e9b12345678901234"
  enable_ipv6          = true
  private_ipv6_address = "2001:db8::1"
  
  ipv6_dns_records = [
    {
      fqdn        = "my-instance-v6.example.com"
      dns_zone_id = "dns12345678901234"
    }
  ]
}
```

**After (v2.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name = "my-instance"
  
  network_interfaces = [
    {
      subnet_id    = "e9b12345678901234"
      ipv6         = true
      ipv6_address = "2001:db8::1"
      
      ipv6_dns_record = [
        {
          fqdn        = "my-instance-v6.example.com"
          dns_zone_id = "dns12345678901234"
        }
      ]
    }
  ]
}
```

### Multiple Network Interfaces (New in v2.x)

**After (v2.x):**

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name = "my-instance"
  
  network_interfaces = [
    {
      subnet_id          = "e9b12345678901234"
      index              = 0
      ipv4               = true
      nat                = true
      security_group_ids = ["enp12345678901234"]
    },
    {
      subnet_id          = "e9b98765432109876"
      index              = 1
      ipv4               = true
      security_group_ids = ["enp98765432109876"]
    }
  ]
}
```

### Advanced Public IP Configuration (New in v2.x)

```hcl
module "instance" {
  source = "terraform-yacloud-modules/instance/yandex"
  
  name = "my-instance"
  
  network_interfaces = [
    {
      subnet_id = "e9b12345678901234"
      nat       = true
      
      pip = {
        description              = "Public IP for my-instance"
        deletion_protection      = true
        ddos_protection_provider = "qrator"
        outgoing_smtp_capability = "enabled"
        
        dns_record = {
          fqdn        = "pip.example.com"
          dns_zone_id = "dns12345678901234"
          ttl         = 300
          ptr         = true
        }
      }
    }
  ]
}
```

## Variable Mapping Reference

| v1.x Variable | v2.x Location |
|---------------|---------------|
| `subnet_id` | `network_interfaces[].subnet_id` |
| `enable_ipv4` | `network_interfaces[].ipv4` |
| `private_ip_address` | `network_interfaces[].ip_address` |
| `enable_ipv6` | `network_interfaces[].ipv6` |
| `private_ipv6_address` | `network_interfaces[].ipv6_address` |
| `enable_nat` | `network_interfaces[].nat` |
| `public_ip_address` | `network_interfaces[].nat_ip_address` |
| `security_group_ids` | `network_interfaces[].security_group_ids` |
| `dns_records` | `network_interfaces[].dns_record` |
| `ipv6_dns_records` | `network_interfaces[].ipv6_dns_record` |
| `nat_dns_records` | `network_interfaces[].nat_dns_record` |
| `create_pip` | Automatic (creates if `nat = true` and no `nat_ip_address`) |

## New Features in v2.x

1. **Multiple Network Interfaces**: Attach multiple network interfaces to a single instance
2. **Per-Interface Configuration**: Each interface can have its own IP settings, security groups, and DNS records
3. **Advanced Public IP Options**: Configure DDoS protection, SMTP capability, and DNS records for public IPs
4. **Interface Indexing**: Control the order of network interfaces with the `index` parameter

## State Migration

If you're upgrading an existing deployment, you may need to migrate Terraform state:

```bash
# For public IP resource (if using auto-created public IP)
terraform state mv 'module.instance.yandex_vpc_address.main[0]' 'module.instance.yandex_vpc_address.main["0"]'
```

**Note**: The exact state migration command depends on your specific configuration. Always backup your state before migration.

## Rollback

If you need to rollback to v1.x:

1. Revert your module version in your Terraform configuration
2. Restore your previous variable configuration
3. Run `terraform init -upgrade` to downgrade the module
4. Review and apply the plan carefully
