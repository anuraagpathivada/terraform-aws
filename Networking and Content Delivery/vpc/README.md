# Terraform AWS VPC Setup 🌐

Set up a simple AWS VPC environment with Terraform. This repository provides all the necessary scripts to get your VPC, along with associated resources like subnets, gateways, and route tables, up and running.

## 📝 Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [Authors](#authors)
- [Acknowledgments](#acknowledgments)

## ⚙️ Prerequisites

- **[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)**: Infrastructure as Code Tool.
- **[AWS CLI](https://aws.amazon.com/cli/)**: Command-line tool for AWS. Ensure to [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) your AWS credentials.

## 🚀 Getting Started

### 1️⃣ Clone the Repository:

```bash
git clone anuraagpathivada/terraform-aws
cd anuraagpathivada/terraform-aws
```

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

## 👨‍💻 Authors

- **Anuraag Pathivada** - Initial work - [GitHub](https://github.com/anuraagpathivada)

## 🎉 Acknowledgments

- Terraform Documentation
- AWS Documentation
