module "catalogue_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value] 
  # this should be in roboshop db subnet
  subnet_id = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value),0)
#   user_data = file("catalogue.sh")
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

  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh $app_version"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/catalogue.sh"
      "sudo sh /tmp/catalogue.sh ${var.app_version}"
    ]
  }
}