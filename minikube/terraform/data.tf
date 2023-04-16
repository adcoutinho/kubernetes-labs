data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_instance_policy_ssm" {
  statement {
    actions = [ 
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["*"]
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/files/userdata.tpl")}"
}

data "template_cloudinit_config" "config" {
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("${path.module}/files/init.cfg")
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/userdata.tpl", {})
  }
}
