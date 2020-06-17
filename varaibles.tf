
variable "cluster_name" {
  description = "What to name the Couchbase cluster and all of its associated resources"
  type        = string
  default     = "couchbase-example"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to null to not associate a Key Pair."
  type        = string
  default     = "terraform-key"
}

variable "data_volume_size" {
  description = "The device size to use for the EBS Volume used for the data directory on Couchbase nodes."
  type        = number
  default     = 100
}


variable "index_volume_size" {
  description = "The device size to use for the EBS Volume used for the index directory on Couchbase nodes."
  type        = number
  default     = 50
}


variable "swap_volume_size" {
  description = "The device size to use for the EBS Volume used for the swap directory on Couchbase nodes."
  type        = number
  default     = 10
}


variable "data_instance_type" {
  description = "Data nodes instance type"
  type        = string
  default     = "r5.xlarge"
}

variable "index_instance_type" {
  description = "Index nodes instance type"
  type        = string
  default     = "r4.xlarge"
}


variable "data_nodes" {
  description = "The port the load balancer should listen on for Sync Gateway requests."
  type        = list(string)
  default     = []
}

variable "index_nodes" {
  description = "The port the load balancer should listen on for Sync Gateway requests."
  type        = list(string)
  default     = []

}

variable "subnet_id" {
  description = "The subnet IDs into which the EC2 Instances should be deployed."
  type        = string
  default     = "subnet-ea8310c1"

}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the Couchbase cluster"
  type        = string
  default     = "vpc-8291abe7"
}


variable "ansible_couchbase_vars" {
  description = "Ansible configuration file name in ansible-module-couchbase project"
  type        = string
  default     = "amazon_enterprise_6.0.2_search"
}



variable "tags" {
  description = "Cluster components tags"
  type        = map
  default = {
    owner       = "Terraform"
  }
}

variable "linux_distribution" {
  description = "ubuntu,amazonlinux"
  type    = string
  default = "amazonlinux"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "install_datadog" {
  default = true
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "product_unit" {
  description = "product_unit"
  type    = string
}

variable "product_component" {
  description = "product_component"
  type    = string
}

variable "service_name" {
  description = "service_name"
  type    = string
}

variable "group" {
  description = "group"
  type    = string
}

variable "ini_file_name" {
  description = "ini file name located in s3"
  type    = string
}
