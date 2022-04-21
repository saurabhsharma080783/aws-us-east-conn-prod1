#################
# This script is covering Networking components- security group and association
#################


resource "aws_security_group" "sec-group-vpc1" {
vpc_id="${aws_vpc.vpc1-prod.id}"
#Name  = "${aws_vpc.vpc1-prod.tags.Name}snet001sg"
description = "Allow SSH, RDP and ICMP traffic"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "RDP"
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    from_port   = 8 # the ICMP type number for 'Echo'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    from_port   = 0 # the ICMP type number for 'Echo Reply'
    to_port     = 0 # the ICMP code
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
tags = {
    Name                          = "${aws_vpc.vpc1-prod.tags.Name}snet001sg"
    ParentOrg                     = "${var.ParentOrg}"
    Env                           = "${var.env1}"
    OpCo                          = "${var.OpCo}"
    Application                   = "${var.Application}"
    Shared                        = "${var.Shared}"
    CreatedBy                     = "${var.CreatedBy}"
  }
  }

