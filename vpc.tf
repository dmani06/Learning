
# Access to provider

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Create VPC
resource "aws_vpc" "dmvpc-test" {
    cidr_block           = "${var.cidr}"
    instance_tenancy     = "${var.instance_tenancy}"
    enable_dns_support   = "${var.enable_dns_support}"
    enable_dns_hostnames = "${var.enable_dns_hostnames}"
    tags {
        Name = "dmvpc-test"
    }
}

# Create 2 Public subnet 

#availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"  - need to check how this works.

resource "aws_subnet" "dmvpc-pub-sub" {
  vpc_id               = "${aws_vpc.dmvpc-test.id}"
  cidr_blocks          = "${element(var.pub_cidr_blocks,count.index)}"
  availability_zone    = "us-east-2a"
  map_public_ip_on_launch  = "${var.map_public_ip_on_launch}"
  count=2
      tags {
          Name = "dmvpc-pub-sub"
      
      }
  }

resource "aws_subnet" "dmvpc-pri-sub" {
  vpc_id               = "${aws_vpc.dmvpc-test.id}"
  cidr_blocks          = "${element(var.pri_cidr_blocks, count,index)}"
  availability_zone    = "us-east-2b"
  map_public_ip_on_launch ="${var.map_public_ip_on_launch}"
  count =2
     tags {
         Name = "dmvpc-pri-sub"
       }
  }
# creation of NAT gateway
resource "aws_eip" "nat" {
	vpc = true
}

resource "aws_nat_gateway" "dmvpc-natgw" {
  allocation_id ="${aws_eip.nat.id}"
  subnet_id = "${element(aws_subnet.dmvpc-pub-sub.*.id, 1)}"
}

# VPC set up for nat


    
    
  
  

