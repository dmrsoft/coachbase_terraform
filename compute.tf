module "ami-ids" {
  source = "github.com/DimaNet/terraform-module-aws-ami.git?ref=v1.0.1"
  distribution = var.linux_distribution
  ami_version_ubuntu = local.ubuntu_default_version
  ami_version_amazonlinux = local.amazon_default_version
}


############################### Initialize inventory ##########################


resource "random_id" "cluster_id" {
  byte_length = 8
}

#####################  Get availibilty zone by subnet ###############

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "data_node" {
  for_each = toset(var.data_nodes)
  ami = module.ami-ids.ami_id
  availability_zone = data.aws_subnet.selected.availability_zone
  instance_type = var.data_instance_type
  subnet_id = var.subnet_id
  key_name = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.couchbase_discover_ec2_profile.name
  user_data = templatefile("${path.module}/${local.user_data_file_name}", {
    module_name=local.module_name
    ansible_repo_bucket=local.ansible_repo_bucket
    module_version=local.module_version
    ini_file_name=var.ini_file_name
  })
  tags = merge(var.tags, {
    Name = each.value,
    cluster_name = var.cluster_name
    couchbase_server_node_services = "${length(var.index_nodes) > 0 ? "data,query,fts" : "data,index,query,fts"}"
    couchbase_server_node_role = "${each.value == var.data_nodes[0] ? "primary" : "additional"}"
    environment = var.environment
    cluster_id = random_id.cluster_id.hex
    couchbase_ansible_vars = var.ansible_couchbase_vars
    product_unit = var.product_unit
    product_component = var.product_component
    service_name = var.service_name
    group = var.group
    install_datadog = var.install_datadog
  })
  lifecycle {
    ignore_changes = [
      tags, user_data]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

}


###### Crerate index nodes #############

resource "aws_instance" "index_node" {
  for_each = toset(var.index_nodes)
  ami = module.ami-ids.ami_id
  availability_zone = data.aws_subnet.selected.availability_zone
  instance_type = var.index_instance_type
  subnet_id = var.subnet_id
  key_name = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.couchbase_discover_ec2_profile.name
  user_data = templatefile("${path.module}/${local.user_data_file_name}", {
    module_name=local.module_name
    ansible_repo_bucket=local.ansible_repo_bucket
    module_version=local.module_version
    ini_file_name=var.ini_file_name
  })
  tags = merge(var.tags,
  {
    Name = each.value,
    cluster_name = var.cluster_name
    couchbase_server_node_services = "index"
    couchbase_server_node_role = "additional"
    environment = var.environment
    cluster_id = random_id.cluster_id.hex
    couchbase_ansible_vars = var.ansible_couchbase_vars
    product_unit = var.product_unit
    product_component = var.product_component
    service_name = var.service_name
    group = var.group
    install_datadog = var.install_datadog
  }
  )
  lifecycle {
    ignore_changes = [
      tags, user_data]
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }

}
