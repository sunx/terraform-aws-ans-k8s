data "template_file" "data_inventory" {
  template = "${file("./inventory.tpl")}"

  vars = {
    masters_ips = "${join("\n", aws_instance.masters.*.public_ip)}"
    nodes_ips = "${join("\n", aws_instance.nodes.*.public_ip)}"
    cplane_ip = "${aws_instance.masters.0.public_ip}"
 } 
}
resource "local_file" "inventory_file" {
  content  = "${data.template_file.data_inventory.rendered}"
  filename = "inventory.yml"
}
resource "local_file" variables_file {

  filename = "variables.yml"
  content = <<EOF
COUNTRY: "${var.COUNTRY}"
LOCALITY: "${var.LOCALITY}"
OU: "${var.OU}"
DOMAIN: "${var.DOMAIN}"
KSSUBNET: "${var.KSSUBNET}"
etcversion: "${var.etcversion}"
LOAD_BALANCER_DNS: "${aws_lb.ks.dns_name}"
LOAD_BALANCER_PORT: "${var.secure-port}"
masters: masters
nodes: nodes
cplane: cplane
EOF
  depends_on = [
    "local_file.inventory_file",
  ]

}
