# terraform_couchbase_installation


Terraform & Ansible project that create couchbase cluster end to end

## This module

-   Creates ec2 instances (Data servers and index servers) , security groups
-   Install couchbase
-   Initialize Cluster and nodes
-   Create Buckets 
-   Create Indexes
-   Add node

Cluster configuration should be added to the module project.
you can use existing configuration and create your own cluster 

## Usage

```hcl
terraform {
  source = "github.com/DimaNet/terraform-module-couchbase.git?ref=v1.0.38"
}
inputs = {

  ansible_couchbase_vars = "ubuntu14.08_community_4.5.1_search"
  linux_distribution = "ubuntu"
  install_datadog = true


  cluster_name = "se-p-couchbase"
  data_volume_size = 100
  swap_volume_size = 10
  data_instance_type = "r5.xlarge"
  data_nodes = [
    "se-p-couchbase-01",
    "se-p-couchbase-02",
    "se-p-couchbase-03"
  ]
  subnet_id = dependency.vpc.outputs.private_subnets[1]
  vpc_id = dependency.vpc.outputs.vpc_id

  tags = {
    owner = "Terraform"
  }
  environment = "production"
  ini_file_name = "search.ini"
  ssh_key_name = "couchbase-key-us-west-2"
  product_unit = "search"
  product_component = "shared"
  service_name = "couchbase"
  group = "search"

}
```
## Terraform versions

Terraform 0.12. Pin module version to `~> v2.0`. Submit pull-requests to `master` branch.

### Notes
- ansible_vars is the couchbase software configuration. you can find the configuration variables in the following link: https://github.com/DimaNet/terraform_couchbase_installation/tree/master/ansible/group_vars. each one of the serer configuration has been tested and ready for use
- This project has been tested on ec2 instances with the following EBS volumes xvda, xvdb, xvdc
- Currently, this project does not support Add node
- Couchbase Ansible project has been taken from  https://github.com/couchbaselabs/ansible-couchbase-server and customized by my needs


## Couchbase versions

Couchbase community edition versions link:
https://www.couchbase.com/downloads/thankyou/community?product=couchbase-server&version=6.0.0&platform=linux-redhat-6&addon=false&beta=false

Couchbase enterprise edition versions link:
https://support.couchbase.com/hc/en-us/articles/213961106-Couchbase-Server-Download-Links


## Maintenance Mode

### Add Nodes
In order to add additional nodes update the following variables with the relevant instance names:
- data_nodes (list)
- index_nodes (list)
