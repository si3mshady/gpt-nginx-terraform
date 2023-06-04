# Define provider
provider "aws" {
  region = "us-east-1" # Change to your desired region
}


variable "hosted_zone_id" {

    default = "Z08654031QGJY8UEMAS55"
  
}
# Create security group
resource "aws_security_group" "instance_sg" {
  name        = "allow-all-my-ip"
  description = "allow all from my IP"

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   
  }
}

# Add inbound rule to allow all ports from your IP address
resource "aws_security_group_rule" "allow_all_ports" {
  security_group_id = aws_security_group.instance_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["70.224.95.9/32"] # Replace with your IP address


}


resource "aws_security_group_rule" "allow_all" {
  security_group_id = aws_security_group.instance_sg.id
  type              = "ingress"
  to_port           = 9100
  protocol          = "-1"
  from_port         = 9100
  
  cidr_blocks       = ["0.0.0.0/0"]
  
}


# Create EC2 instance for prom
resource "aws_instance" "prom" {
  ami           = "ami-0c88b8560fd9b0353" # Change to your desired AMI ID
  instance_type = "t2.large" # Change to your desired instance type
  vpc_security_group_ids = [aws_security_group.instance_sg.id] # Attach security group
  key_name = "sreuni"
  tags = {
    Name = "demo-prom-server"
  }
}

# Create EC2 instance for appserver-exporter
resource "aws_instance" "appserver-exporter" {
  ami           = "ami-05fba1dd756df8ac0" # custom AMI
  instance_type = "t2.large" # Change to your desired instance type
  vpc_security_group_ids = [aws_security_group.instance_sg.id] # Attach security group
  key_name = "sreuni"

  tags = {
    Name = "demo-exporter-appserver"
  }

  user_data = <<-EOF
    #!/bin/bash

    # Download the Docker Compose binary
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # Apply executable permissions to the binary
    sudo chmod +x /usr/local/bin/docker-compose

    wget 






    EOF
}

# Create Elastic IP for prom instance
resource "aws_eip" "eip" {
  instance = aws_instance.prom.id
}

# Create Elastic IP for appserver-exporter instance
resource "aws_eip" "eip2" {
  instance = aws_instance.appserver-exporter.id
}

# Create Route 53 record
resource "aws_route53_zone" "fqdn" {
  name = "sreuniversity.org"
}

resource "aws_route53_record" "fqdn_record" {
  zone_id = var.hosted_zone_id 
  name    = "gpt.sreuniversity.org"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.eip2.public_ip]
}




# vi /etc/prometheus/prometheus.yml
# sudo systemctl restart prometheus