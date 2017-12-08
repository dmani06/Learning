
# Access to provider

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  aws_region     = "${var.aws_region}"
}

# Create VPC
resource "aws_vpc" "dmvpc-test" {
    cidr_block           = "${var.cidr_block}"
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
  cidr_block           = "${element(var.pub_cidr_blocks,count.index)}"
  availability_zone    = "us-east-2a"
  map_public_ip_on_launch  = "${var.map_public_ip_on_launch}"
  count=2
      tags {
          Name = "dmvpc-pub-sub"
      
      }
  }

# Create 2 private subnet 

resource "aws_subnet" "dmvpc-pri-sub" {
  vpc_id               = "${aws_vpc.dmvpc-test.id}"
  cidr_block           = "${element(var.pri_cidr_blocks, count,index)}"
  availability_zone    = "us-east-2b"
  map_public_ip_on_launch ="${var.map_public_ip_on_launch}"
  count =2
     tags {
         Name = "dmvpc-pri-sub"
       }
  }
#create Internet gateway

resource "aws_internet_gateway" "dmvpc-igw" {
  vpc_id ="${aws_vpc.dmvpc-test.id}"
	tags {
	    Name = "dmvpc-igw"
	}
}

# set route rules for IG - Public subnet

resource "aws_route_table" "dmvpc-igroute" {
   vpc_id = "${aws_vpc.dmvpc-test.id}"
   route {
 	   cidr_block = "0.0.0.0/0"
	   gateway_id = "${aws_internet_gateway.dmvpc-igw.id}"
   }
   tags {
	   Name ="dmvpc-igroute"
   }
}

# route association - public subnet (IG)

resource "aws_route_table_association" "dmvpc-pubsub-route" {
  route_table_id = "${aws_route_table.dmvpc-igroute.id}"
  sub_net_id     = "${element(aws_subnet.dmvpc-pub-sub.*.id, count.index)}"
  count = 2
  tag {
     Name = "dmvpc-pubsub-route"
  }
}

# allocate elastic ip for NAT 
resource "aws_eip" "nat" {
	vpc = true
}

# creation of NAT gateway
resource "aws_nat_gateway" "dmvpc-natgw" {
  allocation_id ="${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.dmvpc-pub-sub.*.id, 1)}"
}

# route table set up for NAT

resource "aws_route_table"  "dmvpc-natroute" {
  vpc_id = "${aws_vpc.dmvpc-test.id}"
  route {
  	cidr_block = "0.0.0.0/0"
  	gateway_id = "${aws_nat_gateway.dmvpc-natgw.id}"
  }
  tag {
	  Name = "dmvpc-natroute"
  }
}

# route associations - private subnet (NAT)

resource"aws_route_table_association" "dmvpc-prisub-route" {
  route_table_id = "${aws_nat_gateway.dmvpc-natgw.id}"
  subnet_id      = "${element(aws_subnet.dmvpc-pri-sub.*.id, count.index)}"
  count = 2
  tag {
     Name = "dmvpc-prisub-route"
  }
}
