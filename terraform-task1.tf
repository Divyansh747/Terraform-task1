#aws provider
provider "aws" {
  region     = "ap-south-1"
  profile    = "mytest"
}

#security group
resource "aws_security_group" "ssh-http-1" {
  name        = "ssh-http"
  description = "allow ssh and http"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#aws instance
resource "aws_instance" "aws-os-1" {
  ami               = "ami-0447a12f28fddb066"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  security_groups   = ["ssh-http"]
  key_name          = "test-os-key"
  user_data         = <<-EOF
                       #!/bin/bash
                       sudo yum install httpd -y
                       sudo systemctl start httpd
                       sudo systemctl enable httpd
                       EOF  
  tags = {
    Name = "aws-os-1"
  }
}

#aws ebs
resource "aws_ebs_volume" "ebs-test" {
  availability_zone = "ap-south-1a"
  size              = 2

  tags = {
    Name = "aws-ebs-1"
  }
}

#attaching ebs volume
resource "aws_volume_attachment" "aws-ebs-attach" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs-test.id}"
  instance_id = "${aws_instance.aws-os-1.id}"
}

#aws s3
resource "aws_s3_bucket" "aws-s3-test" {
  bucket = "awstestbucket747"
  acl    = "public-read"
}




