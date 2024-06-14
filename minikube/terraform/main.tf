resource "aws_instance" "this" {
  subnet_id = local.subnet_id

  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "this" {
  name = local.project

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = local.block_device.volume_size
      volume_type = local.block_device.volume_type
    }
  }

  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  image_id = data.aws_ami.ubuntu.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = local.instance_type


  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    delete_on_termination = true
    associate_public_ip_address = local.associate_public_ip_address
    security_groups = [aws_security_group.this.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, {
      Name = local.project
    })
  }

  user_data = "${data.template_cloudinit_config.config.rendered}"
}

#### Security Group ####
resource "aws_security_group" "this" {
  name = "${local.project}-sg"
  description = "Security Group to access ${local.project}"
  vpc_id = local.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow egress to any ip"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_security_group_rule" "this" {
  for_each = local.ports
  type = "ingress"
  description = "Allow acess on port ${each.value.port}"
  from_port = each.value.port
  to_port = each.value.port
  protocol = each.value.protocol
  cidr_blocks = each.value.cidrs
  security_group_id = aws_security_group.this.id
}

#### IAM ####
resource "aws_iam_role" "this" {
  name        = "${local.project}-role"
  description = "Role for ${local.project}"

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "ssm_management_policy" {
  role = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  role = aws_iam_role.this.name
  name        = "${local.project}-instance-profile"
  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}
