# Terraform Elastic Kubernetes Services 🌐

This Terraform configuration automates the setup of a secure and scalable infrastructure on AWS, including VPC, EKS cluster, IAM roles, KMS encryption, and addons like AWS Load Balancer Controller, ensuring high availability and performance for the web application.
There are three variations in how the cluster is created. Please use the necessary scripts to create your own infrastructure.

***Provider Configuration:*** The script configures Terraform to use the AWS provider in a specific region.

***Global Configuration:*** Defines global variables like region and env_type, ensuring consistency and flexibility across the configuration.

***VPC Configuration:*** 
* Utilizes the terraform-aws-modules/vpc/aws module to create a Virtual Private Cloud (VPC) with specified parameters such as name, CIDR block, availability zones, and subnets.
* Defines tags for public and private subnets so that they are visible during the load balancer and auto sclaing configurations
* Tags the resources with environment type.

***EKS Configuration:***
* Configures an Amazon EKS cluster using the terraform-aws-modules/eks/aws module.
* Specifies cluster addons like CoreDNS, kube-proxy, and vpc-cni.
* Sets up managed node groups for frontend and backend with instance types and sizes.
* Configures access entries and tags for the EKS cluster.

***Helm and Kubectl Provider:***
* Configures the Helm provider to interact with Kubernetes using the EKS cluster's endpoint and authentication token.
* Configures the kubectl provider to apply Kubernetes manifests using the EKS cluster's endpoint and authentication token.

***IAM Resources:***
* Defines IAM roles and policies for EKS access, EBS CSI driver, and AWS Load Balancer Controller.
* Attaches policies and permissions to the IAM roles.

***KMS Encryption:***
* Sets up a customer-managed key for EBS volume encryption.
* Configures IAM roles and policies for EBS CSI driver KMS encryption.

***AWS EKS Addons:***
Adds the AWS EBS CSI driver addon to the EKS cluster.

***AWS Load Balancer Controller:***
* Configures IAM roles and policies for the AWS Load Balancer Controller.
* Deploys the AWS Load Balancer Controller using Helm.

***Karpentar: (if you want to implement the karpentar with fargate configuration please rename the file 4-eks_karpenter_fargate.tf_bck to 4-eks_karpenter_fargate.tf and also rename 4-eks_managedng_basic.tf to 4-eks_managedng_basic.tf_bck)***
* EKS Cluster Setup: Configures an Amazon EKS cluster using the specified Terraform module.
* Cluster Addons: Sets up essential cluster addons like coredns, kube-proxy, and vpc-cni.
* Fargate Profiles: Defines Fargate profiles for namespaces such as karpenter and kube-system.
* Karpenter Deployment: Deploys Karpenter, an autoscaling solution, onto the EKS cluster.
* IRSA Configuration: Enables IAM Role for Service Accounts (IRSA) for secure access to AWS resources.
* Helm Provider: Configures Helm to manage Kubernetes applications and dependencies.
* kubectl Provider: Sets up kubectl for interacting with the Kubernetes cluster.
* Repository Authentication: Retrieves credentials for accessing the Helm repository securely.
* Helm Release: Installs Karpenter chart onto the Kubernetes cluster with specified configurations.
* Kubernetes Resources: Creates Kubernetes resources like Node Class, Node Pool, Cluster Role, and Role Binding required by Karpenter.

***AWS Cluster Autoscaler:(if you want to implement the karpentar with fargate configuration please rename the file 4-eks_managedng_cluster_Autoscaler.tf_bck to 4-eks_managedng_cluster_Autoscaler.tf and also rename 4-eks_managedng_basic.tf to 4-eks_managedng_basic.tf_bck)***
* EKS Cluster Configuration: Sets up an Amazon EKS cluster using the specified Terraform module.
* Cluster Addons: Configures essential cluster addons such as coredns, kube-proxy, and vpc-cni.
* VPC Integration: Integrates the EKS cluster with the specified VPC, subnets, and control plane subnets.
* Cluster Version: Specifies the version of the EKS cluster to be deployed (in this case, version 1.29).
* Encryption Configuration: Defines encryption settings for resources like secrets using a custom KMS key.
* Managed Node Group: Configures a default managed node group with specific instance types and scaling settings.
* Cluster Access Permissions: Grants access permissions to specific IAM roles for managing the cluster.
* IAM Roles: Creates IAM roles for the Cluster Autoscaler with appropriate permissions.
* Cluster Autoscaler Deployment: Deploys the Cluster Autoscaler onto the Kubernetes cluster with specified configurations.
* Kubernetes Resources: Creates necessary Kubernetes resources like ServiceAccount, Role, RoleBinding, ClusterRole, ClusterRoleBinding, and Deployment for the Cluster Autoscaler.

## ⚙️ Prerequisites

- **[Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)**: Infrastructure as Code Tool.
- **[AWS CLI](https://aws.amazon.com/cli/)**: Command-line tool for AWS. Ensure to [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) your AWS credentials.
- **Domain Name**: Have a registered domain name that you want to use for your Flask Application.
- **ACM Certificate**: Obtain an ACM certificate for SSL termination.

## 🚀 Getting Started

### 1️⃣ Clone the Repository and update the variables in the terraform.tfvars file:

```bash
git clone anuraagpathivada/terraform-aws
cd anuraagpathivada/terraform-aws/Compute/containerization
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

### How to test the Application deployment and check if the infrastructure is provisioned correctly (Optional):

In the manifests folders there are two yaml files
* sample-app.yaml
* Karpenter_test_deployment.yaml

Assuming that you have already updated your kube config to execure the kubectl commands in your local machine. Now to execute the files please go the manifests directory.

```bash
kubectl apply -f sample-app.yaml 
```

```bash
kubectl apply -f Karpenter_test_deployment.yaml 
```


## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](#). PRs are accepted. For major changes, please open an issue first to discuss what you'd like to change.

## References 

- **[Terraform AWS Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)**

