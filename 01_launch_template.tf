# Steps to provision autoscaling

######### PART - 1 ##############
# 1. Create one instance
# 2. Provision with ansible/shell
# 3. Stop the instance
# 4. Take AMI
# 5. Delete the instance
# 6. Create launch template with AMI

# 1. Create one instance
module "component" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "${local.name}-${var.tags.Component}-ami"
  instance_type          = "t3.micro"
  ami                    = var.centos_ami_id
  vpc_security_group_ids = [var.component_sg_id]
  subnet_id              = local.subnet_id
  iam_instance_profile   = var.iam_instance_profile

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-${var.tags.Component}-ami"
    },
    var.tags
  )
}

# 2. Provision with ansible/shell
resource "null_resource" "component" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.component.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host     = module.component.private_ip
    type     = "ssh"
    user     = "centos"
    password = var.centos_password
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh ${var.tags.Component} ${var.environment}"
    ]
  }
}

# 3. Stop the instance
resource "aws_ec2_instance_state" "component" {
  instance_id = module.component.id
  state       = "stopped"
  depends_on  = [null_resource.component]
}

# 4. Take AMI
resource "aws_ami_from_instance" "component" {
  name               = "${local.name}-${var.tags.Component}-${local.current_time}"
  source_instance_id = module.component.id
  depends_on         = [aws_ec2_instance_state.component]
}

# 5. Delete the instance
resource "null_resource" "component_delete" {
  triggers = {
    instance_id = module.component.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.component.id}"
  }

  depends_on = [aws_ami_from_instance.component]
}

# 6. Create launch template with AMI
resource "aws_launch_template" "component" {
  name = "${local.name}-${var.tags.Component}"

  image_id                             = aws_ami_from_instance.component.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  update_default_version               = true

  vpc_security_group_ids = [var.component_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-${var.tags.Component}"
    }
  }
}
