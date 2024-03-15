# A Comprehensive Guide to Networking 🌐

Networking can seem like an enigma, especially with all the technical terms and configurations to consider. Let's unravel this mystery together.

Before we learn more about Networking, lets first understand what is cloud computing, why has it become popular, and then what are the different types of cloud infrastructure we have currently (obviously because we will concentrate our learning on cloud).

Imagine you have a library at home, and have a good number of books. You can access these books anytime you like and no one else from outside your home can access them unless you give it to them. Basically it is secure and its yours. You would have to maintain these books, shelves, clean them, ensure they are stored properly. It is your responsible to keep them in that way. Now imagine a huge public library where you can access any book without the trouble of maintaining and storing them at your home. You can go there anytime, get what you need and then return once you are done with it.
**Cloud computing** is like this huge public library. Instead of setting up and maintaining your own servers and data centeres, you use the resources provided by the public cloud provider over the internet.

Lets continue with the same analogy , as to understand why there is more interest to move infrastructure to cloud. Suppose we need to expand our library may be add a few 100 books and then ocassionally you need some books which you would use only for a few days or months. Expanding the home library is going to be expensive, incurs more maintenance and could also be time consuming. However, in a the public library, you could access any or all resources on demand. **Cloud Infrastructure** offers similar benefits: **scalability**(get more resources as needed), **cost efficient**(pay only for what you use), **accessibilty**(access the resources from anywhere) and **reduced maintenance**(no need to maintin the physical hardware

## Different Types of Cloud Infrastructure

1. **Public Cloud:** Like a public library, resources are owned and operated by a cloud provider and shared across different organizations.
2. **Private Cloud:** Like having a section of a library exclusively for you with all the benefits but with privacy and control.
3. **Hybrid Cloud:** Combining your home library with access to the public library. You keep some resources privately, and use public cloud for others.) 

## 📝 Table of Contents

1. [Introduction to Networking](#introduction-to-networking)
2. [Decoding the OSI Model](#decoding-the-osi-model)
3. [Diving into AWS Networking](#diving-into-aws-networking)
   - [Virtual Private Cloud (VPC)](#virtual-private-cloud-vpc)
   - [Understanding Subnets: Private vs. Public](#understanding-subnets-private-vs-public)
   - [CIDR Notation: Why so Specific?](#cidr-notation-why-so-specific)
   - [Route Tables and Routes: The Traffic Managers](#route-tables-and-routes-the-traffic-managers)
4. [Gateway to the Internet: Internet and NAT Gateways](#gateway-to-the-internet-internet-and-nat-gateways)
5. [Elastic IP (EIP)](#elastic-ip-eip)
6. [Security Groups (SGs): Your Virtual Firewall](#security-groups-sgs-your-virtual-firewall)
7. [Network Access Control Lists (NACLs): Your Network's Security Guard](#network-access-control-lists-nacls-your-networks-security-guard)

---

## Introduction to Networking

**Why is networking essential?**

Networking, in essence, is the intricate web of connections enabling devices, systems, and applications to interact. Think of a city: its roads, bridges, and highways let people (data) travel between homes (devices). Without these roads, the city would be isolated islands.

**How did computer networking start?**

Imagine two friends wanting to share their diaries. Initially, they might have met up and copied entries by hand. As more friends joined in, they needed a more efficient way. Computer networking began similarly, with computers wanting to share data, evolving from large, isolated systems to the decentralized internet we know today.

---

## Decoding the OSI Model

**What's the OSI Model, and why should we care?**

The OSI (Open Systems Interconnection) model is a conceptual framework used to understand and organize the complex world of network communications. It's like a multi-story building, with each floor representing a different aspect of networking. Each of these floors, or layers, has a specific role in how data is transmitted from one computer to another over a network.
Understanding the OSI model is crucial because it helps us break down the networking process into manageable parts. 

**Lets dive deeper into the individual layers**

Consider an example where you are purchasing a product from amazon.com

**Physical Layer:** 
This is like the physical infrastructure of Amazon – the warehouses, delivery trucks, and the physical route the trucks take.
In terms of the AWS components, this includes the physical infrastructure of AWS, such as global data centers, servers, network cables, and routers.

**Data Link Layer:** 
Think of this layer as the process of packing your Amazon order. The product is placed in a box, labeled correctly, and prepared for shipping in the warehouse.
In terms of the AWS components, AWS Direct Connect links your on-premises network to AWS over a dedicated network connection.

**Network Layer:** 
This is akin to setting the shipping address for your package and choosing the shipping method. It determines how your package will travel from the warehouse to your home.
In terms of the AWS components, Amazon VPC (Virtual Private Cloud) for network layer control, including IP addressing, routing tables, and subnets. Amazon Route 53 for DNS services.

**Transport Layer:** 
This layer ensures that your package arrives in good condition and notifies you of its progress. If you order multiple items, this layer makes sure they all arrive, even if they're shipped separately.
In terms of the AWS components, Elastic Load Balancing distributes incoming application traffic across multiple targets. It operates at the request level (Layer 7) and connection level (Layer 4).

**Session Layer:** 
Imagine this as managing your shopping session. It keeps track of what's in your cart as you shop and ensures that your session remains active until you check out.
AWS establishes and manages sessions with its management console and APIs when you interact with services.

**Presentation Layer:** 
This is like the way Amazon displays products in a format you can understand. It translates product details into a language and currency you're familiar with.
In terms of the AWS components, services like API Gateway and Lambda can manipulate data into the correct format for the application or user, including data encryption and decryption.

**Application Layer:** 
This is the Amazon website interface – the part you interact with. It's where you choose products, read reviews, and place your order.
In terms of the AWS components, Amazon S3 for storing website assets, Amazon EC2 for running web server instances, and Amazon RDS for database services. Services like AWS Elastic Beanstalk for deploying applications.

---

## AWS Networking Basics

### Virtual Private Cloud (VPC)

**What's a VPC?**

Think of a gated community within a large city. The city is the public cloud – a space where many people and businesses reside, sharing the infrastructure. A gated community (VPC) within this city is a space that’s just for you. You have control over the houses, who enters or leaves, and how things are set up within this community. In AWS, a VPC gives you a private space within their public cloud. You control the network environment, including IP address ranges, subnets, and network gateways.

**Why do we need it ?**

For privacy, security, and control. In a VPC, you control the network environment, ensuring that your applications and data are isolated from others. It's like having a private piece of the cloud where you can define your own security and networking settings, just as you would set rules and boundaries in your gated community.

---

### Understanding Subnets: Private vs. Public

**Why do we even need subnets?**

Imagine you've built a mansion with numerous rooms. Each room serves a purpose – a kitchen, a bedroom, a library. Similarly, in our VPC 'mansion', subnets act as these rooms. By creating subnets, we can isolate resources, manage traffic flow, and increase security.

**Okay, but why have private and public subnets?**

Visualize the mansion again. You'd probably want some rooms, like your bedroom, to be private, right? Yet, you'd want your main hall to be accessible to guests.

- **Private Subnets**: These are the 'bedrooms.' Resources in private subnets, like databases, aren't directly accessible from the public internet. They're shielded, adding a layer of security.

- **Public Subnets**: These are like the 'main halls.' Resources here, such as web servers, need to communicate with the outside world (like users) and are thus given direct access routes to the internet.

---

### CIDR Notation: Why so Specific?

**Why do we need CIDRs in a VPC?**

CIDRs provide a systematic way to allocate IP addresses within our network (VPC). Think of it as marking out plots in a new colony. Defining these 'plots' upfront helps organize and prevent overlaps.

**Why can't we use any CIDR we please? Why have a range?**

It's similar to city planning. We can't place buildings randomly. There's a systematic design behind urban development. Similarly, in the world of networking, not all CIDR ranges are considered equal. Some are reserved for special purposes. Others are public ranges that anyone in the world might use. Using such ranges would create chaos as it could conflict with other networks across the internet. Thus, within VPCs, we use specific CIDR ranges to ensure uniqueness and avoid conflicts.

---

### Route Tables and Routes: The Traffic Managers

When you think about a real-world transportation system, routes define paths between two locations. Similarly, in a network, route tables determine where network traffic is directed.

**What is a Route Table?**
A route table contains a set of rules, called routes, that are used to determine where network traffic from a subnet or gateway should be directed. In the context of Amazon VPC, each subnet that you create is associated with a route table.

**Main Components of a Route Table:**

**Routes:** Each entry in a route table specifies the traffic's destination (the final destination) and the path the traffic should take to get there (the next hop).

**Subnet Associations:** Subnets within your VPC must be associated with a route table. Each subnet can only be associated with one route table at a time, but multiple subnets can be associated with the same route table.

**Main and Custom Route Tables:**

**Main Route Table:** By default, every VPC comes with a main route table that you can't delete. If you don't specify a different route table when you create a subnet, the subnet is associated with the main route table.

**Custom Route Tables:** You can create additional route tables in your VPC. This allows for more advanced routing rules and segregations of your network.

**Common Route Types:**

**Local Route:** Automatically included in every route table, allowing communication within the VPC. It's denoted by the CIDR block of the VPC.

**Internet Gateway (IGW) Route:** This route is used to allow or deny traffic from the open internet.

**Virtual Private Gateway (VPG) Route:** Enables AWS VPN connections over a hardware VPN.

**VPC Peering Route:** Allows direct traffic between two VPCs in the same region.

**NAT Gateway/Instance Route:** Used for routing traffic from private subnets to the internet. Traffic is routed through a NAT device, so the source IP of the outgoing traffic becomes the NAT device's IP.

**Transit Gateway Route:** Facilitates inter-VPC traffic across multiple VPCs and VPN connections in a scalable manner.

**Endpoint Route:** Enables traffic to a VPC endpoint service, like S3 or DynamoDB.

**Important Points to Remember:**

**Priority:** Routes in the table are prioritized based on the most specific CIDR range. This means that if there's a more specific route available, it will take precedence over broader routes.

**Propagation:** If you've set up a VPN or Direct Connect, routes can be propagated into your route table automatically, rather than you defining them manually.

**Immutability of Main Route Table:** While you can't delete the main route table, you can edit its routes. Be cautious when editing the main route table; misconfigurations can lead to disruptions.

**Limits:** AWS does impose some limits on the number of route tables you can have and the number of routes per table. However, these limits are often more than sufficient for most use-cases.

**Real-world Example:**

Imagine you live in a large gated community (VPC). The community has multiple exits (gateways). Each exit has clear signs (route tables) showing the paths to reach various destinations. One exit might lead directly to a major highway (internet gateway), while another leads to a nearby community (VPC peering). Within the community, there are lanes and directions that show paths to different blocks or houses (local routes). Just like in this community, in a VPC, you need clear signs (routes) to ensure that traffic smoothly reaches its intended destination without getting lost.

**Why are Route Tables Essential?**

**Control:** You can precisely control the path that your network traffic takes.

**Security:** By configuring specific routes, you can ensure that certain traffic doesn't leak out to the internet or to other unintended destinations.

**Efficiency:** Optimal path selections ensure that the network traffic is processed faster and more efficiently.

**Flexibility:** As your network grows or changes, you can update route tables to reflect the new design.

---

### Gateway to the Internet: Internet and NAT Gateways

**What's an Internet Gateway?**

An Internet Gateway is like a doorway. For your resources in the VPC to communicate with the internet, this doorway (or gateway) has to be present.

**And a NAT Gateway?**

While resources in public subnets can directly talk to the internet, those in private subnets cannot. A NAT (Network Address Translation) Gateway is like a trusted friend who relays messages on behalf of the private resources, allowing them to reach the internet.

---

### Security Groups (SGs): Your Virtual Firewall

In the vast world of AWS networking, Security Groups serve as a virtual firewall for your instances (like EC2 instances) to control both inbound and outbound traffic.

**What's the basic idea behind Security Groups?**

Imagine you're living in a gated community. Each house (instance) in the community has its security system (SG). This security system decides who can visit the house (inbound traffic) and from which doors the residents can exit (outbound traffic).

**Okay, how do they work?**

Security Groups work based on rules defined for allowing or denying traffic:

1. **Inbound Rules**: These control the incoming traffic to an instance. By default, no inbound traffic is allowed until you explicitly specify rules.
2. **Outbound Rules**: These control the outgoing traffic from an instance. The default rule allows all outbound traffic.

**How do I define these rules?**

Each rule in a Security Group consists of:

1. **Protocol**: Specifies the protocol, such as TCP, UDP, or ICMP.
2. **Port Range**: The port or range of ports to allow or deny, like port 80 for HTTP.
3. **Source/Destination**: Specifies the allowed or denied IP addresses or CIDR blocks. In AWS, you can also specify another Security Group as a source or destination, meaning instances associated with the specified SG are allowed or denied traffic.

**Do they have any specific characteristics?**

Yes, a few key features that distinguish Security Groups:

1. **Stateful**: This means if you send a request from your instance (outbound), the response is automatically allowed to come back in, irrespective of inbound rules.
2. **Elastic**: They're associated with an instance, not an IP address. So, if an instance gets stopped and restarted with a new IP address, the SGs still apply.
3. **No explicit 'Deny':** Security Groups only contain 'allow' rules. If there isn't an 'allow' rule for specific traffic, it's automatically denied.

**Can an instance have multiple Security Groups?**

Yes, you can assign multiple SGs to an instance. The traffic is allowed if there's an 'allow' rule in any of the assigned SGs. Think of it as multiple layers of security checks; if one layer permits it, the traffic is good to go.

---

### Elastic IP (EIP)

**What's an Elastic IP?** 🤔

Ever noticed how your home's address doesn't change even if you renovate or change its internal structure? Similarly, in the digital realm of AWS, while internal configurations of instances might vary, you might want the "address" or the IP to remain consistent. That's where Elastic IPs come in!

An Elastic IP (EIP) is a static, public IPv4 address you can allocate within your AWS account. It's like having a permanent address for your cloud resources, no matter how they evolve or change.

**Why is it called "Elastic"? 🤷**

The "elastic" nature of the EIP doesn't refer to its flexibility to change (it's static, after all). Instead, it's about how you can easily move and remap the IP address to other instances in your account. Think of it like a mobile phone number that you can transfer between devices.

**Why would I need an EIP? 🧐**

1. **Stable Websites & Apps**: Running a website? You don't want your domain's IP address to change, causing accessibility issues.
2. **Quick Recovery**: If an EC2 instance fails, remap the EIP to another instance for quick recovery.
3. **Strict Access Control**: For situations where you whitelist IP addresses (like secured databases or third-party services), a consistent IP address saves time and avoids access issues.

**Got it! But are there limitations? 🚧**

Yes!

1. **Limited Numbers**: AWS doesn't offer unlimited EIPs. IPv4 addresses are limited globally.
2. **Costs Involved**: While the allocation might be free, there's a charge if it's not associated with a running instance. Think of it as a "storage fee" for keeping that IP reserved for you.

** Real-world Analogy 🌍**

Imagine phone numbers. Moving to a new city might get you a new local number. But what if you're a business? You'd prefer a permanent number, right? Even if you shift your office, you can retain that "business" number. That's your EIP in this analogy.

**How does it tie back to AWS networking? 🕸**

- **Internet Gateway**: For an EC2 instance with an EIP to talk to the internet, your VPC should be equipped with an Internet Gateway.
  
- **NAT Devices**: Using a NAT instance? Associate it with an EIP to let instances in a private subnet reach out to the internet.
  
- **Safety First**: EIPs don't bypass security. Access is still governed by Security Groups and NACLs.

---

### Network Access Control Lists (NACLs): Your Network's Security Guard
NACLs are one of the essential security layers within Amazon VPC. If your VPC is a fortified castle, NACLs would be the guards at the main gate, ensuring that only authorized visitors can enter or leave.

**But we already have security groups, right? What's the difference?**

Great question!

**Security Groups (SGs):** Think of SGs as apartment door locks. They operate at the instance level, meaning each 'apartment' (or EC2 instance) can have its unique lock (SG). Security Groups are stateful; if you send a request from your instance, the response is automatically allowed, irrespective of outbound rules.

**Network Access Control Lists (NACLs):** NACLs operate at the subnet level, guarding all 'apartments' (instances) within that 'building' (subnet). Unlike SGs, NACLs are stateless. This means if you allow an incoming request from an IP, you must also allow the outgoing response to that IP.

**So, how do NACLs work?**

NACLs work by examining the source and destination IP addresses and ports of network traffic. Each NACL contains a list of rules that determine whether traffic is allowed or denied.

**What's the structure of a NACL rule?**

Each rule in a NACL has:

**Rule Number:** This determines the order in which rules are evaluated. Lower numbers are evaluated before higher numbers.
**Protocol:** Specifies the protocol, such as TCP, UDP, or ICMP.
**Port Range:** Specifies the allowed port range, like 80 for HTTP.
**Source/destination:** The IP address range for the source/destination.
**Allow/Deny:** The rule's action, either to allow or deny the traffic.

**Any notable quirks or characteristics of NACLs I should know?**

Yes, a few key points to remember:

**Order Matters:** NACLs evaluate rules in ascending order (by rule number). Once a rule matches traffic, it's applied regardless of any subsequent rules that might also match.
**Default NACL:** Every VPC comes with a default NACL that allows all inbound and outbound traffic. However, if you create a custom NACL, it denies all traffic by default until you add rules.
**NACLs are Stateless:** As mentioned earlier, if you create an inbound rule allowing traffic from a specific IP, you must also create an outbound rule to permit the response.

**When should I use NACLs over Security Groups?**

Both serve as essential layers of security and can be used in tandem. However, if you need a broad rule at the subnet level, like blocking traffic from a particular IP range, NACLs would be the way to go. Conversely, for instance-specific rules, SGs are more suitable.

By incorporating NACLs effectively, you're adding a vital security layer to your AWS resources. It's like having a vigilant security guard who's always on the lookout, ensuring that only legitimate traffic enters or exits your network. Safe networking! 🛡️🔒

---


