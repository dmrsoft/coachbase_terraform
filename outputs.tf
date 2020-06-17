output "data-node-private-ip" {
  value = aws_instance.data_node
}


output "index-node-private-ip" {
  value = aws_instance.index_node
}
