# Terraform Elastic Beanstalk 🌐

AWS Elastic Beanstalk is a Platform as a Service (PaaS) offering from Amazon Web Services (AWS) that simplifies the deployment and management of web applications. It allows developers to upload their application code and automatically handles the deployment, capacity provisioning, load balancing, auto-scaling, and health monitoring of the application environment. With Elastic Beanstalk, developers can focus on building their applications without worrying about the underlying infrastructure, making it easier to deploy and manage scalable web applications on AWS.

***VPC (Virtual Private Cloud):*** The VPC provides a virtual network for the Elastic Beanstalk environment, allowing you to launch AWS resources in a logically isolated section of the AWS Cloud. It includes private and public subnets distributed across multiple availability zones for high availability and fault tolerance.

***Elastic Beanstalk Application:*** The Elastic Beanstalk application is a container for the code that you want to deploy. It provides an easy-to-use interface for deploying and managing web applications without worrying about the underlying infrastructure.

***Elastic Beanstalk Environment:*** The Elastic Beanstalk environment is where your application runs. It automatically handles the deployment, capacity provisioning, load balancing, auto-scaling, and health monitoring of your application. This environment is configured with settings such as VPC configuration, instance type, load balancer settings, and auto-scaling parameters.

***S3 Bucket:*** An S3 bucket is created to store the application code bundle that will be deployed to Elastic Beanstalk. The code bundle is uploaded to the S3 bucket, and Elastic Beanstalk retrieves it during the deployment process.

***Route 53 Record:*** A Route 53 DNS record is created to map the Elastic Beanstalk environment's URL to a domain name. This allows users to access the deployed application using a custom domain name.

## ⚙️ Prerequisites

- **[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)**: Infrastructure as Code Tool.
- **[AWS CLI](https://aws.amazon.com/cli/)**: Command-line tool for AWS. Ensure to [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) your AWS credentials.
- **Domain Name**: Have a registered domain name that you want to use for your Flask Application.
- **ACM Certificate**: Obtain an ACM certificate for SSL termination.

## 🚀 Getting Started

### 1️⃣ Clone the Repository and update the variables in the terraform.tfvars file:

```bash
git clone anuraagpathivada/terraform-aws
cd anuraagpathivada/terraform-aws/Compute/elasticbeanstalk
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

