provider "aws" {
  region = "${var.aws-region}"
  profile = "${var.aws-profile}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

locals {
 masterslist = "${aws_instance.masters.*.public_ip}"
 mastercrop = "${slice(local.masterslist, 1, var.masters_count)}"
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = <<EOT
       ansible-playbook main.yml -i inventory.yml -b
    EOT
  }
  depends_on = [
    "local_file.variables_file",
  ]
  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
       rm -rf roles/k8s/files/*
    EOT
  }

}
