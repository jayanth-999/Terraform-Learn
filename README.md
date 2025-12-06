# Terraform Zero to Enterprise Learning Path

This repository contains the code and examples for a complete Terraform learning journey, taking you from "Hello World" to Advanced DevOps scenarios on Azure.

## Prerequisites
- **Terraform**: v1.0+
- **Azure CLI**: v2.0+ (Logged in via `az login`)

## Repository Structure

### Phase 1: The Fundamentals
| Folder | Module | Description |
|--------|--------|-------------|
| `01-basics` | **Basics** | Introduction to Resources, `init`, `plan`, `apply`, `destroy`. |
| `02-modules` | **Reusability** | How to package resources into reusable Modules. |
| `03-backend` | **State** | Understanding `terraform.tfstate` and simulating remote backends. |
| `04-workspaces` | **Environments** | Using Workspaces to manage `dev` and `prod` with one codebase. |
| `05-enterprise` | **Structure** | Best practices for directory layout and CI/CD checks (`fmt`, `validate`). |

### Phase 2: Real World Azure
| Folder | Module | Description |
|--------|--------|-------------|
| `06-azure-backend` | **Bootstrapping** | Creating the Azure Storage Account to hold the state file. |
| `07-migration` | **Remote State** | Configuring the `azurerm` backend to store state in the cloud. |

### Phase 3: Advanced DevOps
| Folder | Module | Description |
|--------|--------|-------------|
| `08-networking` | **Complex Modules** | Dynamic VNET creation using `for_each` and complex variables. |
| `09-compute` | **Agents** | Provisioning VMs with `cloud-init` to auto-install software on boot. |
| `10-import` | **Disaster Recovery** | How to `import` existing/legacy resources into Terraform state. |
| `11-debugging` | **Troubleshooting** | A broken configuration to practice debugging with `TF_LOG`. |

### Phase 3: Automation
| Folder | Module | Description |
|--------|--------|-------------|
| `12-python-automation` | **Python Wrapper** | A `deploy.py` script to automate Terraform runs based on user input. |
| `13-ansible-integration` | **Ansible** | Triggering Ansible playbooks via `local-exec` for configuration management. |

### Phase 4: Cloud Native
| Folder | Module | Description |
|--------|--------|-------------|
| `14-kubernetes` | **K8s & Helm** | Provisioning AKS and deploying Nginx with the Helm provider. |


## Common Commands

### Workflow
```bash
terraform init      # Initialize directory (download providers/modules)
terraform fmt       # Format code
terraform validate  # Check syntax
terraform plan      # Preview changes
terraform apply     # Create/Update resources
terraform destroy   # Delete resources
```

### Debugging
If you encounter issues, enable verbose logging:
**PowerShell**:
```powershell
$env:TF_LOG="DEBUG"
terraform plan
```
**Bash**:
```bash
export TF_LOG=DEBUG
terraform plan
```

## Disaster Recovery Cheatsheet

**Scenario: Deleted Cloud Resource**
1. Run `terraform plan` (Terraform detects the missing resource).
2. Run `terraform apply` (Terraform recreates it).

**Scenario: Deleted State File (or Existing Resource)**
1. Find the Resource ID in Azure Portal.
2. Run `terraform import <resource_type>.<name> <resource_id>`.

---
*Created during an interactive learning session.*
