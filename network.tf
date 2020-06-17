
######################### Security Groups ####################################
resource "aws_security_group" "couchbase_security_group" {
  name_prefix = var.cluster_name
  description = "Security group for the ${var.cluster_name} launch configuration"
  vpc_id      = var.vpc_id

  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.tags,
    {
      Name         = "${var.cluster_name}-security-group",
      cluster_name = var.cluster_name
  })


}

##########################  Securty groups rules ##########################

resource "aws_security_group_rule" "allow_all_outbound" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]

  security_group_id = aws_security_group.couchbase_security_group.id
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
  "0.0.0.0/0"]

  security_group_id = aws_security_group.couchbase_security_group.id
}


resource "aws_security_group_rule" "allow_in_couchbase" {
  type        = "ingress"
  from_port   = 8091
  to_port     = 8093
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}

resource "aws_security_group_rule" "allow_in_couchbase2" {
  type        = "ingress"
  from_port   = 9100
  to_port     = 9105
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}


resource "aws_security_group_rule" "allow_in_couchbase3" {
  type        = "ingress"
  from_port   = 9998
  to_port     = 9999
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}


resource "aws_security_group_rule" "allow_in_couchbase4" {
  type        = "ingress"
  from_port   = 11207
  to_port     = 11215
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}



resource "aws_security_group_rule" "allow_in_couchbase5" {
  type        = "ingress"
  from_port   = 18091
  to_port     = 18093
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}

resource "aws_security_group_rule" "allow_in_couchbase6" {
  type        = "ingress"
  from_port   = 4369
  to_port     = 4369
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}

resource "aws_security_group_rule" "allow_in_couchbase7" {
  type        = "ingress"
  from_port   = 21100
  to_port     = 21299
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.couchbase_security_group.id
}




resource "aws_network_interface_sg_attachment" "sg_couchbase_attachment" {
  security_group_id    = aws_security_group.couchbase_security_group.id
  network_interface_id = aws_instance.data_node[each.value].primary_network_interface_id
  for_each             = toset(var.data_nodes)
  depends_on           = [aws_instance.data_node]
}

resource "aws_network_interface_sg_attachment" "sg_couchbase_attachment_index" {
  security_group_id    = aws_security_group.couchbase_security_group.id
  network_interface_id = aws_instance.index_node[each.value].primary_network_interface_id
  for_each             = toset(var.index_nodes)
  depends_on           = [aws_instance.data_node]
}

