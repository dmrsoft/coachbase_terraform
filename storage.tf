
########################## DATA Volume - Data node ############################

resource "aws_ebs_volume" "data_volume_data_node" {
  for_each          = toset(var.data_nodes)
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.data_volume_size
  type              = "gp2"
  tags              = merge(var.tags, { Name = each.value, cluster_name = var.cluster_name })
}

resource "aws_volume_attachment" "data_volume_data_node_attahcement" {
  for_each    = toset(var.data_nodes)
  device_name = local.data_volume_device_name
  volume_id   = aws_ebs_volume.data_volume_data_node[each.value].id
  instance_id = aws_instance.data_node[each.value].id
  depends_on = [
    aws_instance.data_node,
  aws_ebs_volume.data_volume_data_node]
  force_detach = true

}


//####################### SWAP Volume - Data node ############################

resource "aws_ebs_volume" "swap_volume_data_node" {
  depends_on        = [aws_volume_attachment.data_volume_data_node_attahcement]
  for_each          = toset(var.data_nodes)
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.swap_volume_size
  type              = "gp2"
  tags              = merge(var.tags, { Name = each.value, cluster_name = var.cluster_name })
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_volume_attachment" "swap_volume_data_node_attahcement" {
  for_each    = toset(var.data_nodes)
  device_name = local.swap_volume_device_name
  volume_id   = aws_ebs_volume.swap_volume_data_node[each.value].id
  instance_id = aws_instance.data_node[each.value].id
  depends_on = [
    aws_instance.data_node,
  aws_ebs_volume.swap_volume_data_node]
  force_detach = true
}
//
//####################### DATA Volume - Index node ############################


resource "aws_ebs_volume" "data_volume_index_node" {
  for_each          = toset(var.index_nodes)
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.index_volume_size
  type              = "gp2"
  tags              = merge(var.tags, { Name = each.value, cluster_name = var.cluster_name })
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_volume_attachment" "data_volume_index_node_attahcement" {
  for_each    = toset(var.index_nodes)
  device_name = local.index_volume_device_name
  volume_id   = aws_ebs_volume.data_volume_index_node[each.value].id
  instance_id = aws_instance.index_node[each.value].id
  depends_on = [
    aws_instance.index_node,
  aws_ebs_volume.data_volume_index_node]
  force_detach = true
}

//
//####################### SWAP Volume - Index node ############################
//

resource "aws_ebs_volume" "swap_volume_index_node" {
  for_each          = toset(var.index_nodes)
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = var.swap_volume_size
  type              = "gp2"
  tags              = merge(var.tags, { Name = each.value, cluster_name = var.cluster_name })
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_volume_attachment" "swap_volume_index_node_attahcement" {
  for_each    = toset(var.index_nodes)
  device_name = local.swap_volume_device_name
  volume_id   = aws_ebs_volume.swap_volume_index_node[each.value].id
  instance_id = aws_instance.index_node[each.value].id
  depends_on = [
    aws_instance.index_node,
  aws_ebs_volume.swap_volume_index_node]
  force_detach = true
}
