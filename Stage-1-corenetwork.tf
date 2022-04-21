#################
# This script is covering Networking components- VPC, Subnet, route table, route table association,
# Transit gateway, Transit Gateway attachment, Tags
#################

/*data "aws_s3_bucket" "bucket1" {
bucket = "${aws_s3_bucket.s3bucketbackend}"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}


terraform {
  backend "s3" {
      encrypt = true
      bucket = "s3bucketvon2022"
      key = "deploy-stage/terraform_stage1.tfstate"
      region = "us-east-1"
      dynamodb_table = "test-bucket-von2022-dydb"
  }
}
*/

#################
# VPCs
#################

resource "aws_vpc" "vpc1-prod" {
  cidr_block = "100.118.0.0/23"
/*  tags = {
    Name = var.vpcname
    stage = "${var.stage}"
    env = "prod"
  }
*/
   tags                            = {
    Name                          = var.vpcname
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
}

#################
# Subnets
#################

resource "aws_subnet" "vpc1-prod-sub-a" {
  vpc_id     = "${aws_vpc.vpc1-prod.id}"
  cidr_block = "100.118.0.0/28"
  availability_zone = "${var.az1}"

/*  tags = {
    Name = "${aws_vpc.vpc1-prod.tags.Name}snet001"
  }
*/
    tags                            = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet001"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
}

resource "aws_subnet" "vpc1-prod-sub-b" {
  vpc_id     = "${aws_vpc.vpc1-prod.id}"
  cidr_block = "100.118.1.0/28"
  availability_zone = "${var.az2}"
#  security_group_id = aws_security_group.sec-group-vpc1.id[]

 /* tags = {
    Name = "${aws_vpc.vpc1-prod.tags.Name}snet002"
  }
*/
  tags                            = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet002"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
}


# Route Tables
## Usually unecessary to explicitly create a Route Table in Terraform
## since AWS automatically creates and assigns a 'Main Route Table'
## whenever a VPC is created. However, in a Transit Gateway stage,
## Route Tables are explicitly created so an extra route to the
## Transit Gateway could be defined

resource "aws_route_table" "vpc1-prod-snet002" {
  vpc_id = "${aws_vpc.vpc1-prod.id}"

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = "${aws_ec2_transit_gateway.coretgw1.id}"
  }

  /*tags = {
    Name = "${aws_vpc.vpc1-prod.tags.Name}snet002rt"
    env        = "prod"
    stage = "${var.stage}"
  }
*/
   tags                            = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet002rt"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }

  depends_on = [aws_ec2_transit_gateway.coretgw1]
}

resource "aws_route_table" "vpc1-prod-snet001" {
  vpc_id = "${aws_vpc.vpc1-prod.id}"
    route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = "${aws_ec2_transit_gateway.coretgw1.id}"
  }

  /*tags = {
    Name = "${aws_vpc.vpc1-prod.tags.Name}snet001rt"
    env        = "prod"
    stage = "${var.stage}"
  }*/

  tags                            = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet001rt"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
  depends_on = [aws_ec2_transit_gateway.coretgw1]
}

# Main Route Tables Associations
## Forcing our Route Tables to be the main ones for our VPCs,
## otherwise AWS automatically will create a main Route Table
## for each VPC, leaving our own Route Tables as secondary

/*resource "aws_route_table_association" "main-rt-vpc1-prod" {
  subnet_id         = "${aws_subnet.vpc1-prod-sub-b.id}"
  route_table_id = "${aws_route_table.vpc1-prod-rtb.id}"
}
*/
resource "aws_route_table_association" "vpc1-prod-snet001" {
  subnet_id = "${aws_subnet.vpc1-prod-sub-a.id}"
  route_table_id = "${aws_route_table.vpc1-prod-snet001.id}"
}

resource "aws_route_table_association" "vpc1-prod-snet002" {
  subnet_id = "${aws_subnet.vpc1-prod-sub-b.id}"
  route_table_id = "${aws_route_table.vpc1-prod-snet002.id}"
}

###########################
# Transit Gateway Section #
###########################

# Transit Gateway
## Default association and propagation are disabled since our stage involves
## a more elaborated setup where
## - Prod and Dev VPCs can reach themselves and the Core VPC
## - the Core VPC can reach all VPCs
## - the DMZ VPC can only reach the Core VPC
## The default setup being a full mesh stage where all VPCs can see every other
resource "aws_ec2_transit_gateway" "coretgw1" {
  description                     = "Transit Gateway testing stage with 4 VPCs, 2 subnets each"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags                            = {
    Name                          = "${var.coretgw1name}"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
}

# VPC attachment

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc1-prod" {
  subnet_ids         = ["${aws_subnet.vpc1-prod-sub-a.id}", "${aws_subnet.vpc1-prod-sub-b.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.coretgw1.id}"
  vpc_id             = "${aws_vpc.vpc1-prod.id}"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
    tags                            = {
    Name                          = "${var.coretgw1name}-to-${var.vpcname}"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
  depends_on = [aws_ec2_transit_gateway.coretgw1]
}


# Route Tables

resource "aws_ec2_transit_gateway_route_table" "tgw-core-rt" {
  transit_gateway_id = "${aws_ec2_transit_gateway.coretgw1.id}"
 /* tags               = {
    Name             = "tgw-core-rt"
    stage         = "${var.stage}"
  }*/

   tags                            = {
    Name                          = "${var.vpcname}tgwrt"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }

  depends_on = [aws_ec2_transit_gateway.coretgw1]
}

# Route Tables Associations
## This is the link between a VPC (already symbolized with its attachment to the Transit Gateway)
##  and the Route Table the VPC's packet will hit when they arrive into the Transit Gateway.
## The Route Tables Associations do not represent the actual routes the packets are routed to.
## These are defined in the Route Tables Propagations section below.

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc1-prod-assoc" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc1-prod.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw-core-rt.id}"
}

# Route Tables Propagations
## This section defines which VPCs will be routed from each Route Table created in the Transit Gateway

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-dev-to-vpc1-prod" {
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc1-prod.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway_route_table.tgw-core-rt.id}"
}


