# Terraform VPC Module

In this script, we're introducing you to one of the most foundational elements of AWS: The Virtual Private Cloud (VPC). Let's walk through the Terraform script that uses a VPC module to help you understand each component.

## Understanding the Terraform VPC Module:

### 1. **Module Definition**:

```hcl
module "vpc" {
```

This line defines a new module named "vpc". In Terraform, modules allow you to encapsulate a piece of infrastructure setup for reuse.

### 2. **Source and Version**:

```hcl
source  = "terraform-aws-modules/vpc/aws"
version = "2.66.0"
```

Here, we specify where to fetch the VPC module's code from. It's sourced from the official Terraform AWS modules repository. By setting the version to "2.66.0", we ensure we're using a specific version of this module for predictability.

### 3. **Inputs to the Module**:

Each of the following is an input variable being passed to the VPC module:

- `name`: Name of the VPC, set to the value of `var.vpc_name`.
- `cidr`: The CIDR block for the VPC.
- `azs`: Availability Zones where subnets will be created.
- `private_subnets`: CIDR blocks for private subnets.
- `public_subnets`: CIDR blocks for public subnets.
- `enable_nat_gateway`: A boolean to decide if a NAT Gateway should be provisioned.
- `single_nat_gateway`: A boolean to decide if only one NAT Gateway should be created for the VPC.
- `enable_dns_hostnames`: Allows instances in this VPC to have internal DNS hostnames.

### 4. **Tags**:

```hcl
tags = {
  "Organization_Name" = "${var.org_name}"
  "Env_type" = "${var.env_type}"
}
```

Tags are key-value pairs of metadata you can assign to AWS resources. Here, we're adding two tags: one for the organization's name and one for the environment type (e.g., "Development", "Production").

---

**Note**: All the variables prefixed with `var.` are values that you will provide. These make the script flexible and adaptable to different setups.

When you run this script with `terraform apply`, Terraform will provision a VPC based on your configurations in AWS. It's a great way to start your AWS journey with a structured and organized network!
