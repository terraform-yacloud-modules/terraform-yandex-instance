# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Terraform module for creating Yandex Cloud VM instances. It provides a flexible interface for deploying compute instances with various configurations including networking, storage, GPU support, and KMS encryption.

## Development Commands

### Terraform Validation and Formatting
```bash
# Format all Terraform files recursively
terraform fmt -recursive

# Validate Terraform configuration
terraform validate

# Initialize Terraform (needed before validation)
terraform init
```

### Linting
```bash
# Run TFLint (requires setup)
tflint --init
tflint -f compact

# Check code formatting
terraform fmt -recursive -check=true -diff
```

### Pre-commit Hooks
The repository uses pre-commit hooks for code quality. Install and run:
```bash
pre-commit install
pre-commit run --all-files
```

Hooks include:
- `terraform_fmt`: Auto-format Terraform files
- `terraform_validate`: Validate Terraform syntax
- `terraform_docs`: Auto-generate documentation in README.md
- `terraform_tflint`: Lint Terraform code
- Standard checks (merge conflicts, EOF, trailing whitespace)

### Testing Examples
```bash
# Test the minimal example
cd examples/minimal
terraform init
terraform plan

# Test the full example
cd examples/full
terraform init
terraform plan
```

## Architecture

### Resource Creation Flow

1. **Image Selection** (data.tf): The module uses a priority system for selecting VM images:
   - Highest priority: `var.image_snapshot_id` (snapshot-based)
   - Medium priority: `var.image_id` (specific image ID)
   - Lowest priority: `var.image_family` (defaults to "ubuntu-2004-lts")

2. **SSH Key Management** (main.tf:8-16): The module supports two approaches:
   - Auto-generate SSH keys via `tls_private_key` resource when `generate_ssh_key = true`
   - Use existing SSH public key from file when `ssh_pubkey` is provided

3. **Public IP Address Management** (pip.tf): The module has conditional logic for public IPs:
   - If `create_pip = true`: creates a `yandex_vpc_address` resource and assigns it to the instance
   - If `create_pip = false`: uses the value from `public_ip_address` variable directly

4. **Secondary Disks** (disk.tf): Disks are created via `for_each` loop filtering only enabled disks:
   - Each disk is named as `{instance_name}-{disk_key}`
   - Supports KMS encryption via `secondary_disks_kms_key_ids` map
   - Disks are dynamically attached in main.tf:92-107

5. **Main Instance Resource** (main.tf:18-170): The compute instance ties everything together:
   - Metadata is conditionally set (docker-compose file, SSH keys, user-data)
   - Boot disk supports both regular images and snapshots
   - Dynamic blocks for secondary disks, filesystems, DNS records
   - Network interface with support for IPv4/IPv6, NAT, and DNS records

### Key Patterns

**Conditional Resource Creation**: Resources use `count` for conditional creation:
- `tls_private_key.this[0]` - only when `generate_ssh_key = true`
- `yandex_vpc_address.main[0]` - only when `create_pip = true`

**For-Each Pattern**: Used for multi-instance resources:
- `yandex_compute_disk.this` - creates multiple secondary disks
- Secondary disk attachment uses nested for-each merging disk info with variables

**Dynamic Blocks**: Extensively used for optional nested configurations:
- `host_affinity_rules` - placement affinity
- `secondary_disk` - additional storage
- `filesystem` - filesystem attachments
- `dns_record`, `ipv6_dns_record`, `nat_dns_record` - DNS configurations
- `timeouts` - operation timeouts

**Folder ID Resolution**: Uses `data.yandex_client_config.client.folder_id` as default when `var.folder_id` is null, allowing users to omit folder_id if working in default folder.

### Important Variables

**Required Variables**:
- `name` - Base name for all resources
- `subnet_id` - VPC subnet ID

**Image Priority** (see main.tf:2-7):
- `image_snapshot_id` overrides everything
- `image_id` overrides `image_family`
- `image_family` is the default fallback

**Disk Encryption**:
- `boot_disk_kms_key_id` - Encrypts boot disk
- `secondary_disks_kms_key_ids` - Map of disk names to KMS key IDs

**New Features** (added in recent releases):
- `metadata_options` - Configure instance metadata service access (GCE/AWS endpoints)
- `dns_records`, `ipv6_dns_records`, `nat_dns_records` - DNS record management
- `filesystems` - Attach Yandex Cloud filesystems
- `gpu_cluster_id` and `gpus` - GPU support
- `timeouts` - Configurable operation timeouts

## Documentation

The README.md is auto-generated using terraform-docs. The content between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` tags is automatically updated by the pre-commit hook `terraform_docs`.

To manually update documentation:
```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```

## CI/CD Pipeline

The `.github/workflows/pipeline.yml` runs on push to main and on pull requests:

**Linters Job**:
- `terraform fmt --recursive -check=true --diff`
- `tflint --init && tflint -f compact`
- `tfsec` (security scanning)
- `checkov` (policy-as-code scanning)

**Semver Job**:
- Automatically creates version tags and GitHub releases
- Uses semantic versioning with `v` prefix
- Only runs on main branch after linters pass

## Examples

- `examples/minimal/` - Basic instance with minimal configuration
- `examples/full/` - Comprehensive example demonstrating all features including DNS records, KMS encryption, metadata options, secondary disks, and cloud-init user data

## Module Outputs

Key outputs for module consumers:
- `instance_id`, `instance_private_ip`, `instance_public_ip` - Instance identifiers
- `ssh_key_pub`, `ssh_key_prv` - Generated SSH keys (sensitive)
- `compute_disks` - Secondary disk details with device names
- `instance_fqdn`, `instance_status`, `instance_created_at` - Instance metadata

## Requirements

- Terraform >= 1.3
- Yandex Cloud provider >= 0.72.0
- TLS provider >= 3.1.0 (for SSH key generation)
