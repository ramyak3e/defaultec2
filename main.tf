
terraform {
	required_providers {
	aws = {
	source = "hashicorp/aws"
	version = "5.14.0"
	}
	}
	}
	
	provider "aws" {
	access_key = "AKIAYIPWMS6TG3ZZAMBE"
	secret_key = "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"
	region = "ap-south-1"
	}


	resource "aws_default_subnet" "default_az1" {
 	availability_zone = "ap-south-1a"

  	tags = {
    	Name = "Default subnet for ap-south-1"
  	}
	}
	
	resource "aws_default_vpc" "default_vpc" {

	}
	resource "aws_security_group" "aws_sg" {
	name        = "allow_ssh"
  	description = "Allow ssh inbound traffic"

	vpc_id      = aws_default_vpc.default_vpc.id
	
	ingress {
	description = "SSH from the internet"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	
	 tags = {
	    Name = "allow_ssh"
	  }
	}
	resource "aws_instance" "aws_ins_web" {
	
	ami = "ami-0f5ee92e2d63afc18"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.aws_sg.id]
	associate_public_ip_address = true
	user_data  = base64encode(file("userdata.sh"))
	
	tags = {
	Name = "my instance"
	}
	
	}
	
	output "instance_ip" {
	value = aws_instance.aws_ins_web.public_ip
	}

