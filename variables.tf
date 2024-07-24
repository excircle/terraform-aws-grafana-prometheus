variable "application_name" {
  description = "Application Name"
  type = string
  default = "Grafana"
}

variable "sshkey" {
  description = "SSH key to use with EC2 host"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"
}

variable "ec2_ami_image" {
  description = "EC2 AMI Image"
  type = string
  default = "ami-03c983f9003cb9cd1" # "ami-03c983f9003cb9cd1" us-west-2 AMI | Ubuntu 22.04.4 LTS (Jammy Jellyfish)
}

variable "ec2_key_name" {
  description = "EC2 Key Pair Name"
  type = string
  default = "grafana-key"
}

variable "subnet" {
  description = "Subnet ID to deploy EC2 instance"
  type = string
}

variable "aws_iam_policy_name" {
  description = "IAM Policy Name"
  type = string
  default = "Grafana-Describe-Instances"
}

variable "aws_iam_role_name" {
  description = "IAM Role Name"
  type = string
  default = "Grafana-EC2-CLI-Role"
}

variable "ec2_instance_profile_name" {
  description = "EC2 Instance Profile Name"
  type = string
  default = "Grafana-EC2-Profile"
}

variable "createdby_tag" {
  description = "Tag for created by"
  type = string
  default = "Terraform"
}

variable "owner_tag" {
  description = "Tag for owner"
  type = string
  default = "Alexander Kalaj"
}

variable "security_group" {
    description = "Security Group ID"
    type = string
}