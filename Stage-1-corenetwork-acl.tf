#################
# This script is covering Networking components- Network ACL and association with subnet
#################

resource "aws_network_acl" "vpc1snet001" {
  vpc_id = "${aws_vpc.vpc1-prod.id}"
 # subnet_ids = "${aws_subnet.vpc1-prod-sub-a.id}"

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

tags = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet001nac"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
}

resource "aws_network_acl_association" "snet001association" {
  network_acl_id = "${aws_network_acl.vpc1snet001.id}"
#  vpc_id = "${aws_vpc.vpc1-prod.id}"
 subnet_id = "${aws_subnet.vpc1-prod-sub-a.id}"
}

resource "aws_network_acl" "vpc1snet002" {
  vpc_id = "${aws_vpc.vpc1-prod.id}"
 # subnet_ids = "${aws_subnet.vpc1-prod-sub-a.id}"

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

tags = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet002nac"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
}



resource "aws_network_acl_association" "snet002association" {
  network_acl_id = "${aws_network_acl.vpc1snet002.id}"
#  vpc_id = "${aws_vpc.vpc1-prod.id}"
 subnet_id = "${aws_subnet.vpc1-prod-sub-b.id}"
}
