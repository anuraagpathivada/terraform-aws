# Terraform Cloud Front Setup

Amazon CloudFront is a content delivery network (CDN) service provided by Amazon Web Services (AWS). It accelerates the delivery of static and dynamic web content, including images, videos, CSS files, and JavaScript code, to users around the world. CloudFront caches content at edge locations, which are distributed globally, reducing latency and improving transfer speeds for end users.

***Provider Configuration:*** The scripts configure Terraform to use the AWS provider and specify the required version.
Global Variables: Global variables such as region, ACM certificate ARN, domain name, and S3 bucket name are defined. These variables are used throughout the configuration to maintain consistency and flexibility.

***S3 Bucket Creation:*** The scripts create an S3 bucket named "practice-app" for hosting static content. Versioning is enabled for the S3 bucket, ensuring that multiple versions of objects can be stored and retrieved.

***S3 Bucket Policy:*** A bucket policy is applied to the S3 bucket to allow access from Amazon CloudFront. This policy ensures that CloudFront distributions can fetch objects from the S3 bucket securely.

***CloudFront Distribution:*** A CloudFront distribution is created to serve the content stored in the S3 bucket globally. The distribution is configured with the specified bucket name, domain name, and SSL certificate for secure communication.

***CloudFront Origin Access Control (OAC):*** An Origin Access Control is created to restrict access to the S3 bucket, ensuring that only CloudFront can access the content.

***Route 53 Record:*** A Route 53 DNS record is created to map the CloudFront distribution's domain name to a custom domain name, allowing users to access the content via a user-friendly URL.

## 📝 Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [Authors](#authors)
- [Acknowledgments](#acknowledgments)

## ⚙️ Prerequisites

- **[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)**: Infrastructure as Code Tool.
- **[AWS CLI](https://aws.amazon.com/cli/)**: Command-line tool for AWS. Ensure to [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) your AWS credentials.
- **Domain Name**: Have a registered domain name that you want to use for your CloudFront distribution.
- **ACM Certificate**: Obtain an ACM certificate for SSL termination.

## 🚀 Getting Started

### 1️⃣ Clone the Repository and update the variables in the terraform.tfvars file:

```bash
git clone anuraagpathivada/terraform-aws
cd anuraagpathivada/terraform-aws/Networking_and_Content_Delivery/cloudfront
```

***Ensure to fill in the required variables such as region, acm_certificate, domain_name, and bucket_name in the terraform.tfvars file.***

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

