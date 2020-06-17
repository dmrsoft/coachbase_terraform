
terraform {
  source = "github.com/DimaNet/terraform-module-couchbase.git?ref=v1.0.38"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "keypair" {
  config_path = "../../infra/key-pairs/couchbase-key-pair"
    mock_outputs = {
    key_name = "couchbase-key-us-west-2"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  skip_outputs = true
}


dependency "vpc" {
  config_path = "../../infra/vpc"
  mock_outputs = {
     private_subnets = ["subnet-1", "subnet-0ce9cff45d4a30749" ]
     vpc_id = "vpc-00dbb6c157dd20ecb"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
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
