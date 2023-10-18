module "catalogue_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  # it should be in Roboshop DB subnet
  subnet_id = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value), 0)
  //user_data = file("catalogue.sh")
  tags = merge(
    {
        Name = "Catalogue-DEV-AMI"
    },
    var.common_tags
  )
}

resource "null_resource" "cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue_instance.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = module.catalogue_instance.private_ip
  }

  #copy the file
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh ${var.app_version}"
    ]
  }
}

# stop instance to take AMI
resource "aws_ec2_instance_state" "catalogue_instance" {
  instance_id = module.catalogue_instance.id
  state       = "stopped"
  depends_on = [null_resource.cluster]
}


resource "aws_ami_from_instance" "catalogue_ami" {
  name               = "${var.common_tags.component}-${local.current_time}"
  source_instance_id = module.catalogue_instance.id
  depends_on = [ aws_ec2_instance_state.catalogue_instance ]
}

resource "null_resource" "delete_instance" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    ami_id = aws_ami_from_instance.catalogue_ami.id
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue_instance.id}"
  }
  depends_on = [ aws_ami_from_instance.catalogue_ami ]
}