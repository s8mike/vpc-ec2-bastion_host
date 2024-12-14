1. FOOT AND SOME EXPLANATORY NOTES.

INSTANCES.TF

1. The settings enable_dns_support = true and enable_dns_hostnames = true are used during the creation of an Amazon Virtual Private Cloud (VPC) to enable DNS resolution and DNS hostnames within your VPC. Here's why you might need to enable these features:
1. enable_dns_support = true
Purpose: This setting enables DNS resolution within the VPC.
Why it's needed:
When set to true, the VPC allows instances to resolve DNS hostnames to IP addresses.
It ensures that your instances can communicate with AWS services by domain name (e.g., ec2.amazonaws.com, s3.amazonaws.com), rather than having to rely solely on static IPs.
If you're using AWS services like Route 53 or EC2 instances that depend on DNS, enabling DNS support ensures proper network and service integration.

2. enable_dns_hostnames = true
Purpose: This setting allows EC2 instances within your VPC to receive public DNS hostnames.
Why it's needed:
When set to true, each EC2 instance that is launched with a public IP will get a unique, publicly resolvable DNS name (e.g., ec2-203-0-113-25.compute-1.amazonaws.com).
This is essential for applications or systems that need to refer to EC2 instances by hostname (e.g., a load balancer or external users accessing a web server).
Without this, instances won't be given public DNS names, which may make them harder to identify or access over the internet.





2. ISSUES WITH THE CODE:

1. SECURITY_GROUPS.TF
I had initial issue with the code given to me but had to be corrected with the explanation below:
The error you're encountering—`"an attribute named security_groups_ids is not expected here"`—indicates that you're using the incorrect attribute name `security_group_ids` for specifying the security group in your `aws_instance` resources.

### Why it shouldn't be there:

1. **Incorrect Attribute Name**: The correct attribute name is `security_groups` (plural) instead of `security_group_ids` (singular) when defining security groups for an EC2 instance in Terraform.

   - **`security_group_ids`** is not a valid attribute in the `aws_instance` resource; it is used in certain other resources like `aws_security_group_rule`.
   - The correct attribute for associating security groups is `security_groups`, which expects a list of security group names or IDs. So, you should use `security_groups` instead of `security_group_ids`.

### Corrected Code:

```hcl
# Public EC2 Instance
resource "aws_instance" "public_instance" {
  ami               = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type     = "t2.micro"
  key_name          = "your key pair name"
  subnet_id         = aws_subnet.public_subnet.id
  security_groups   = [aws_security_group.public_sg.name]  # Use .name or .id
  associate_public_ip_address = true

  tags = local.tags
}

# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami               = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type     = "t2.micro"
  key_name          = "your key pair name"
  subnet_id         = aws_subnet.private_subnet.id
  security_groups   = [aws_security_group.private_sg.name]  # Use .name or .id

  tags = local.tags
}
```

### Key Changes:

1. **`security_groups` Attribute**: 
   - I've replaced `security_group_ids` with `security_groups`, which is the correct attribute to use when assigning security groups to an EC2 instance.
   - You can reference either the `.name` or `.id` of the security group. Typically, `.name` is used for clarity, but both `.name` and `.id` will work fine, depending on the context. 

### Reason for the Change:
- The `aws_instance` resource in Terraform expects `security_groups` to be a list of strings, where each string is the name or ID of a security group. The `security_group_ids` attribute does not exist in this resource type.


INSTANCE.TF
1. Place holder ami for aws default ami:
# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami               = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]

  tags = local.tags
}


Initialize and Apply Terraform

Once you have all the files, run the following Terraform commands to initialize and apply the configuration:
Initialize Terraform:

 terraform init


Check the Plan:

 terraform plan
 Review the changes Terraform will make.


Apply the Configuration:

 terraform apply
 Terraform will create the VPC, subnets, security groups, and EC2 instances. Once complete, it will display the public IP of the public EC2 instance.


SSH into the Public EC2 Instance:

Once the EC2 instances are created, use the public IP of the public EC2 instance (displayed by Terraform) to SSH into it.
ssh -i your-key.pem ec2-user@<public-ip>

Replace your-key.pem with your private key file and <public-ip> with the actual public IP address output by Terraform.

SSH from Public EC2 Instance to Private EC2 Instance:

Now that you are logged into the public EC2 instance, SSH into the private EC2 instance (only accessible from the public instance).
First, get the private IP address of the private EC2 instance (either from the AWS Console or by running the following command on the public EC2 instance):

 curl http://169.254.169.254/latest/meta-data/local-ipv4


SSH into the private EC2 instance:

 ssh ec2-user@<private-ip>


Install Packages:

Once logged into the private EC2 instance, you can install packages, such as Apache, to verify everything is working.
For example:
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

Clean Up Resources:

Once you’re done testing, make sure to destroy the resources to avoid incurring charges:
terraform destroy

This will remove all the infrastructure that Terraform created.
