# Terraform Azure Linux VM Project

## Overview

This project provisions a complete Azure environment using **Terraform** to automate the deployment of a Linux Virtual Machine (VM) with networking, security, and Docker installation. The configuration is designed for reproducibility and compliance with organizational policies, such as requiring a Network Security Group (NSG) on the NIC.

---

## Tools Used

- **Terraform**: Infrastructure as Code (IaC) tool for provisioning and managing Azure resources.
- **Azure Portal**: Occasionally used for manual resource creation and verification.
- **Azure CLI**: Used for authentication (`az login`) and resource inspection.
- **VS Code**: Editor for writing and managing Terraform and shell/cloud-init scripts.
- **SSH**: For connecting to the provisioned VM.

---

## What This Project Does

1. **Creates an Azure Resource Group** (`mtc-resources`) in the `East US` region.
2. **Creates a Virtual Network** (`mtc-network`) and a Subnet (`mtc-subnet`).
3. **Creates a Network Security Group** (`mtc-sg`) with an inbound rule (`mtc-dev-rule`) allowing all traffic (for demo/dev purposes).
4. **Associates the NSG with the Subnet** to comply with Azure policy.
5. **Creates a Public IP Address** (`mtc-ip`) with Basic SKU and Dynamic allocation.
6. **Creates a Network Interface** (`mtc-nic`) attached to the subnet and public IP, with the required NSG association.
7. **Creates a Linux Virtual Machine** (`mtc-vm`) using an Ubuntu 20.04 LTS image, with SSH key authentication.
8. **Bootstraps the VM with Docker** using a custom data script (`customdata.tpl`).
9. **Configures local SSH** using a template (`mac-ssh-script.tpl`) for easy access.
10. **Outputs the VM's public IP address** for quick connection.

---

## Key Files

- `main.tf`: Main Terraform configuration for all Azure resources.
- `variables.tf`: Defines input variables (e.g., `host_os`).
- `customdata.tpl`: Bash script for installing Docker on the VM at boot.
- `mac-ssh-script.tpl`: Template for updating your local SSH config.
- `terraform.tfstate`: Terraform state file (do not edit manually).

---

## Steps Performed

1. **Terraform Initialization and Authentication**
   - Ran `terraform init` to initialize the project.
   - Logged in to Azure using `az login` and set the correct subscription.

2. **Resource Creation**
   - Defined all resources in `main.tf`.
   - Used `terraform apply` to provision resources.
   - When Azure policy required an NSG on the NIC at creation, either:
     - Upgraded the AzureRM provider to v3.x+ to use `network_security_group_id` (if possible), or
     - Created the NIC in the Azure Portal and imported it with `terraform import`.

3. **Manual Steps (if needed)**
   - Created and configured the NIC in the Azure Portal when policy blocked Terraform-only creation.
   - Associated the public IP and NSG with the NIC via the portal UI.
   - Imported manually created resources into Terraform state.

4. **VM Provisioning**
   - Used a custom data script (`customdata.tpl`) to install Docker automatically on the VM.
   - Verified Docker installation by SSH-ing into the VM.

5. **SSH Configuration**
   - Used a template (`mac-ssh-script.tpl`) to update the local SSH config for easy access to the VM.

6. **Output**
   - Used a Terraform output to display the VM name and public IP after deployment.

---

## Troubleshooting & Lessons Learned

- **Azure Policy Enforcement**: Some policies require NSG attachment at NIC creation, which may require provider upgrades or manual steps.
- **Provider Version Compatibility**: Features like `network_security_group_id` on NICs require AzureRM provider v3.x+.
- **Resource Importing**: Manual Azure Portal resources can be imported into Terraform state for continued management.
- **Dynamic Public IPs**: Azure only allocates a dynamic public IP after the VM is running and the NIC is attached.
- **Custom Data Scripts**: Ensure correct syntax and permissions for successful VM bootstrapping.

---

## How to Use

1. Clone the repository and navigate to the project directory.
2. Run `terraform init` to initialize.
3. Run `az login` to authenticate with Azure.
4. Run `terraform apply` to provision resources.
5. Use the outputted public IP to SSH into your VM.

---

## Cleanup

To destroy all resources:

```sh
terraform destroy
```

---

## References

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Portal](https://portal.azure.com)
- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)
- [Cloud-init Documentation](https://cloud-init.io/)
- [Learn Terraform with Azure by Building a Dev Environment](https://www.youtube.com/watch?v=V53AHWun17s)

---