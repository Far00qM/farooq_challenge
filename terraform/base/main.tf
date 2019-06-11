#terraform vpc block
resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
}

#terraform getting available zones from AWS

data "aws_availability_zones" "available" {}

#terraform subnet block

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidrs_subnet1}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
}



#terraform code for route table

resource "aws_route_table_association" "public_assocation" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}


#terraform internet gateway

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

# Route tables

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

}

# securtiy group only allowing 80 and 443
resource "aws_security_group" "public_sg" {
  name        = "sg_public"
  description = "public access on port 80 and 443"
  vpc_id      = "${aws_vpc.vpc.id}"

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#launch template 
resource "aws_launch_template" "far" {
  name = "far"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
  
  image_id               = "${var.dev_ami}"
  instance_type = "${var.dev_instance_type}"
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = ["${aws_security_group.public_sg.id}"]
  user_data = "${base64encode(data.template_file.asg-template.rendered)}"
}

#autoscaling group for creating scaling infrastruce

resource "aws_autoscaling_group" "far" {
  name                      = "far-terraform-nginx"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = ["${aws_subnet.public.id}"]
  launch_template {
    id      = "${aws_launch_template.far.id}"
    version = "$Latest"
  }
  lifecycle {
    create_before_destroy = true

  }

}

