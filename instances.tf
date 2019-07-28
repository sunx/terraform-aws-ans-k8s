resource "aws_instance" "masters" {
  count = "${var.masters_count}"
  instance_type = "${var.aws_type}"
  ami = "${var.aws_amis}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.masters.id}"]
  subnet_id = "${aws_subnet.ks.id}"
  user_data = <<-EOF
     #cloud-config
     hostname: "master${count.index + 1}"
     manage_etc_hosts: true
     users:
       - default
       - name: "${var.aws-key-name}"
         sudo: ALL=(ALL) NOPASSWD:ALL
         groups: users, admin
         primary_group: "${var.aws-key-name}"
         shell: /bin/bash
         ssh_authorized_keys:
           - "${file(var.public_key_path)}"
     EOF
  tags = {
    project = "ks"
    role = "master"
  }
}

resource "aws_instance" "nodes" {
  connection {
    user = "${var.aws-key-name}"
  }
  count = "${var.nodes_count}"
  instance_type = "${var.aws_type}"
  ami = "${var.aws_amis}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.nodes.id}"]
  subnet_id = "${aws_subnet.ks.id}"
  user_data = <<-EOF
     #cloud-config
     hostname: "node${count.index + 1}"
     manage_etc_hosts: true
     users:
       - default
       - name: "${var.aws-key-name}"
         sudo: ALL=(ALL) NOPASSWD:ALL
         groups: users, admin
         primary_group: "${var.aws-key-name}"
         shell: /bin/bash
         ssh_authorized_keys:
           - "${file(var.public_key_path)}"
     EOF
  tags = {
    project = "ks"
    role = "node"
  }
}
