# Terraform VPC Module

In this script, we're introducing you to one of the most foundational elements of AWS: The Virtual Private Cloud (VPC). Let's walk through the Terraform script that uses a VPC module to help you understand each component.
We're leveraging the [`terraform-aws-vpc`](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) module, which simplifies the process, but it's essential to understand each component for those moments when you decide to take the granular route.

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


---

# Deep Dive into AWS VPC Components

## Virtual Private Cloud (VPC)

A **Virtual Private Cloud (VPC)** is a virtual network dedicated to your AWS account. Think of it as your private space in the AWS cloud, isolated from other users. Within this VPC, you can launch AWS resources, like EC2 instances, in a virtual network that you define.

### Why use a VPC?
It provides a controlled environment, ensuring that resources are secure, easily managed, and can communicate with each other and other networks as you define.

## CIDR Block

**CIDR** stands for Classless Inter-Domain Routing. It's a method used to allocate IP addresses and route IP packets in a network. A CIDR block notation looks like this: `192.168.1.0/24`.

- `192.168.1.0` is the network address.
- `/24` denotes how many of the first bits of the address are the network prefix (in this case, 24 bits). The remaining bits (32-24=8 bits) are for hosts (devices) in the network.

### How are IPs Calculated in CIDR?

Given a `/24` block, we have 2^8 = 256 possible addresses. But in AWS:

- The first four addresses (`x.x.x.0` through `x.x.x.3`) and the last address (`x.x.x.255` in a `/24` block) are reserved for AWS networking purposes.
- This leaves you with `256 - 5 = 251` usable addresses.

## Private and Public Subnets

A **subnet** is a range of IP addresses in your VPC. When setting up a VPC, dividing it into subnets helps organize your network, control traffic flow, and assign specific security policies to groups of resources.

### What are they?

- **Private Subnet**: Any instances that you launch into this subnet can't directly communicate with the internet; they can only communicate with other instances in the VPC.
  
- **Public Subnet**: Instances can communicate directly with the internet, as long as they have an Elastic IP or Public IP.

### Why the division?

Separating resources between public and private subnets ensures that vulnerable or critical resources aren't exposed to the public internet. For example, databases might be placed in a private subnet while web servers are in a public subnet.

## NAT Gateway

**NAT Gateway** allows instances in a private subnet to initiate outbound IPv4 traffic to the internet but prevents unsolicited inbound traffic from reaching those instances.

### Why use a NAT Gateway?

While instances in a private subnet can't directly access the internet, they might need to initiate outbound traffic, for example, to fetch software updates. The NAT Gateway facilitates this while maintaining the security and privacy of those instances.

## Why only one NAT Gateway?

Having a single NAT Gateway can be cost-effective and simpler to manage. However, it's essential to understand the trade-offs:

- **Cost**: Each NAT Gateway is charged per hour and for the data processed.
- **Availability**: While NAT Gateways are designed to be highly available within an availability zone, having one for multiple zones can be a single point of failure.

However, the given Terraform script indicates the use of a single NAT Gateway (`single_nat_gateway = true`), which means that even if you have multiple public subnets in different availability zones, they all share a single NAT Gateway. This setup is often a balance between cost and redundancy.

## Route Tables

A **Route Table** contains a set of rules, called routes, that are used to determine where network traffic is directed. Each subnet in your VPC must be associated with a route table, which controls the traffic routing for the subnet.

### Components:

- **Destination**: This refers to the CIDR block of traffic to match. For example, a destination of `0.0.0.0/0` represents all possible IP addresses, essentially meaning "all traffic."

- **Target**: Specifies where to route the traffic. It could be a Network Interface, Internet Gateway, NAT Gateway, Virtual Private Gateway, etc.

### Types of Route Tables:

1. **Main Route Table**: By default, every VPC comes with a main route table. If you don't explicitly associate a subnet with a route table, the subnet uses the main route table. It's a good practice to avoid modifying the main route table.

2. **Custom Route Table**: You can create additional custom route tables in your VPC. You might use custom route tables to:

    - Route traffic in a subnet (public) to the internet through an Internet Gateway.
    - Route traffic in a subnet (private) to the internet through a NAT Gateway in another (public) subnet.
  
### Why are Route Tables Important?

- **Flexibility and Security**: Route tables provide the ability to finely control the traffic in and out of subnets. For instance, you might want a public subnet where resources can access the internet and a private subnet where resources are isolated from the internet.

- **Explicit Traffic Flow**: It helps in explicitly defining how traffic should flow, ensuring no unexpected data transfer occurs, which can be crucial for security and cost control.

### How does it relate to our Terraform script?

In the provided Terraform VPC module, route tables are implicitly created and managed for you. When you define public and private subnets:

- Public subnets usually get a route pointing `0.0.0.0/0` to the Internet Gateway, making them "public."
  
- Private subnets, if associated with a NAT Gateway, get a route pointing `0.0.0.0/0` to the NAT Gateway, allowing outbound internet traffic but keeping inbound traffic restricted.

---

Understanding route tables is pivotal as they are the gatekeepers of your VPC, ensuring that traffic flows as you intend and helping to secure your AWS resources.

---

With this understanding, you're better equipped to appreciate the nuances of AWS VPC and its various components. As you build within AWS, you'll find that these foundational concepts will significantly influence your architecture decisions.