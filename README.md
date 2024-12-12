







ISSUES WITH THE CODE:
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
  subnet_id         = aws_subnet.public_subnet.id
  security_groups   = [aws_security_group.public_sg.name]  # Use .name or .id
  associate_public_ip_address = true

  tags = local.tags
}

# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami               = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type     = "t2.micro"
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
