#output "data-config" {
#  value = "${data.template_file.data_etcd.*.rendered}"
#  value = "${join(",", data.template_file.data_config.*.rendered)}"
#}

#output "etcd_config" {
#  value = "${element(data.template_file.etcd_config.*.rendered, count.index)}"
#}
#resource "local_file" "etcd_yaml_file" {
#  count = "${var.masters_count}"
#  content  = "${element(data.template_file.data_etcd_yaml.*.rendered, count.index)}"
#  filename = "etcd-file${count.index + 1}.yml"
#}
#
#resource "local_file" "etcd_service_file" {
#  count = "${var.masters_count}"
#  content  = "${element(data.template_file.data_etcd_service.*.rendered, count.index)}"
#  filename = "etcd-serv${count.index + 1}.yml"
#}
#resource "local_file" "config_file" {
#  count = "${var.masters_count}"
#  content  = "${element(data.template_file.data_config_yaml.*.rendered, count.index)}"
#  filename = "config-file${count.index + 1}.yml"
#}
#resource "local_file" "config_file" {
#  count = ("${var.masters_count}" + "${var.nodes_count}")
#  content  = "${element(local.conchosts, count.index)}"
#  filename = "conc${count.index + 1}.yml"
##  filename = "masterips.yml"
#}
#
#output "locals_out_masters" {
#  value = "${local.concmasters}"
#}
#output "locals_out_nodes" {
#  value = "${local.concnodes}"
#}
#output "locals_out_hosts" {
##  value = "${local.conchosts}"
#  value = "${join("\n", data.template_file.data_config.*.rendered)}"
#}
#resource "local_file" "config_file" {
#  count = ("${var.masters_count}" + "${var.nodes_count}")
#  content  = "${element(local.conchosts, count.index)}"
#  filename = "conc${count.index + 1}.ip"
#}
#data "template_file" "tmp3" {
#  count = "${var.masters_count}"
#  template = "${element(local.conchosts, count.index)}"
#}
#output "conc" {
#  value = "${data.template_file.tmp3.*.rendered}"
#}


data "template_file" "tmp1" {
  count = "${var.masters_count}"
  template = "${element(aws_instance.masters.*.public_ip, count.index)}"
}
output "Masters" {
  value = "${data.template_file.tmp1.*.rendered}"
}

data "template_file" "tmp2" {
  count = "${var.nodes_count}"
  template = "${element(aws_instance.nodes.*.public_ip, count.index)}"
}
output "Nodes" {
  value = "${data.template_file.tmp2.*.rendered}"
}

