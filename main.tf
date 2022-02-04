provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "credentials-path"
  profile                 = "customprofile"
}



resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "production"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_prefix[0].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_prefix[0].name
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.subnet_prefix[1].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_prefix[1].name
  }
}


# #creating vpc 
# resource "aws_vpc" "MYVPC" {
#   cidr_block       = "10.0.0.0/16"
#   default = ""
# }

# #creating internet-gateway
# resource "aws_internet_gateway" "my-gw" {
#   vpc_id = aws_vpc.MYVPC.id

# }
# #custom-route-table
# resource "aws_route_table" "my-route-table" {
#  vpc_id = aws_vpc.MYVPC.id
 
#  route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.my-gw.id
#   }

#  route {
#     ipv6_cidr_block = "::/0"
#     gateway_id      = aws_internet_gateway.gw.id
#   }
#  }

# #create subnet

# resource "aws_subnet" "subnet-1" {
#   vpc_id            = aws_vpc.MYVPC.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"

# }

# # Associate subnet with Route Table
# resource "aws_route_table_association" "route-associate" {
#   subnet_id      = aws_subnet.subnet-1.id
#   route_table_id = aws_route_table.my-route-table.id

# }

# # Create Security Group to allow port 22,80,443
# resource "aws_security_group" "allow_web" {
#   name        = "allow_web_traffic"
#   description = "Allow Web inbound traffic"
#   vpc_id      = aws_vpc.MYVPC.id

#   ingress {
#     description = "HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


# }

# #  Create a network interface with an ip in the subnet that was created 

# resource "aws_network_interface" "web-server-nic" {
#   subnet_id       = aws_subnet.subnet-1.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.allow_web.id]

# }
# #  Assign an elastic IP to the network interface created 

# resource "aws_eip" "one" {
#   vpc                       = true
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on                = [aws_internet_gateway.my-gw]
# }

# output "server_public_ip" {
#   value = aws_eip.one.public_ip
# }

# #  Create Ubuntu server and install/enable apache2

# resource "aws_instance" "web-server-instance" {
#   ami               = "ami-085925f297f89fce1"
#   instance_type     = "t2.micro"
#   availability_zone = "us-east-1a"
#   key_name          = "main-key"

#   network_interface {
#     device_index         = 0
#     network_interface_id = aws_network_interface.web-server-nic.id
#   }

#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install apache2 -y
#                 sudo systemctl start apache2
#                 sudo bash -c 'echo your very first web server > /var/www/html/index.html'
#                 EOF
#   tags = {
#     Name = "web-server"
#   }
# }



# output "server_private_ip" {
#   value = aws_instance.web-server-instance.private_ip

# }

# output "server_id" {
#   value = aws_instance.web-server-instance.id
# }

