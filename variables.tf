variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "availability_zone" {
  default = "ap-southeast-1-bkk-1a"
}

variable "network_border_group" {
  default = "ap-southeast-1-bkk-1"
}

variable "PROJECT_NAME" {
  default = "localzone-proj-bkk"
}

variable "subnet_ids" {
  default = ["subnet-006231b70e9b11401", "subnet-0cdcb697d0a8d325c", "subnet-0cdcb697d0a8d325c"]
}

variable "amazon_linux_ami" {
  default = "ami-0ce792959cf41c394"
}

variable "ubuntu_ami" {
  default = "ami-06292ffafe4773f6c"
}

variable "nat_gateway_ami" {
  default = "ami-06803096834b68a2f"
}

variable "general_key_pair" {
  default = "localzone-proj-general-kp"
}

variable "localzone_vpc_id" {
  default = "vpc-0d08bff6cc5db8d14"
}

variable "private_subnets_cidr" {
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}

variable "public_subnets_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "dbservers_private_ip" {
  default = ["10.0.3.10", "10.0.4.10", "10.0.5.10"]
}

# variable "dbmanager_private_ip" {
#   default = "10.0.3.10"
# }

variable "webservers_private_ip" {
  default = ["10.0.3.80", "10.0.4.80"]
}

variable "fileservers_private_ip" {
  default = ["10.0.3.120", "10.0.4.120", "10.0.5.120"]
}
