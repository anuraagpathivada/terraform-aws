# Terraform Compute (EC2) 🌐

This Terraform configuration automates the setup of a secure and scalable infrastructure on AWS, including VPC, EC2 instances, ALB, autoscaling, and DNS routing, ensuring high availability and performance for the web application

***Provider Configuration:*** The script configures Terraform to use the AWS provider in a specific region.

***Global Configuration:*** Defines global variables like region and env_type, ensuring consistency and flexibility across the configuration.

***VPC Configuration:*** 
* Utilizes the terraform-aws-modules/vpc/aws module to create a Virtual Private Cloud (VPC) with specified parameters such as name, CIDR block, availability zones, and subnets.
* Tags the resources with environment type.

***EC2 Configuration:***
* Sets up security groups to allow SSH traffic to and from the EC2 instances.
* Creates security groups to allow internet traffic to ALB, backend, and frontend instances.
* Configures security group rules for ingress and egress traffic.
* Defines a key pair for SSH access to the EC2 instances.
* Creates an EC2 instance (bastion) with SSH access, assigns it to the appropriate subnet, and provisions it with necessary files and configurations.
* Sets up launch templates for the web application and backend instances, including user data scripts for installing dependencies, cloning repositories, and configuring the applications.
* Configures autoscaling groups for both web application and backend instances.

***Application Load Balancer (ALB):*** Creates an ALB to distribute incoming application traffic.
* Sets up target groups for the web application and backend.
* Configures listeners and listener rules to route traffic between the ALB and target groups.
* Redirects HTTP traffic to HTTPS for security.

***Route 53 Configuration:***
* Retrieves the Route 53 hosted zone ID based on the specified domain name.
* Creates Route 53 records to route traffic from the domain name to the ALB's DNS name.

## ⚙️ Prerequisites

- **[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)**: Infrastructure as Code Tool.
- **[AWS CLI](https://aws.amazon.com/cli/)**: Command-line tool for AWS. Ensure to [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) your AWS credentials.
- **Domain Name**: Have a registered domain name that you want to use for your Flask Application.
- **ACM Certificate**: Obtain an ACM certificate for SSL termination.

## 🚀 Getting Started

### 1️⃣ Clone the Repository and update the variables in the terraform.tfvars file:

```bash
git clone anuraagpathivada/terraform-aws
cd anuraagpathivada/terraform-aws/Compute/ec2
```

***Update all the necessary values in the terraform.tfvars file before proceeding to the next step.***

### 2️⃣ Initialize Terraform:

```bash
terraform init
```

This command initializes Terraform in your directory and downloads the necessary provider plugins.

### 3️⃣ Planning Phase:

Preview the changes that will be made:

```bash
terraform plan
```

### 4️⃣ Apply Changes:

If the plan looks good, apply the changes:

```bash
terraform apply
```

You'll be prompted to confirm the changes. Type `yes` to proceed.

### 5️⃣ Destroy (Optional):

To tear down the infrastructure when you're done:

```bash
terraform destroy
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](#). PRs are accepted. For major changes, please open an issue first to discuss what you'd like to change.

## References 

- **[Terraform AWS Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)**

