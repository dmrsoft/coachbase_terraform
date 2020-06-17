

locals {
  module_name = "ansible-module-couchbase"
  module_version = "1.0.42"
  ansible_repo_bucket = "dima-ansible-modules"
}



locals {
  data_volume_device_name = "/dev/xvdb"
  index_volume_device_name = "/dev/xvdb"
  swap_volume_device_name = "/dev/xvdc"
}

locals {
  ubuntu_default_version = "trusty-14.04"
  amazon_default_version = "2018.03.0.20200206.0"

}

locals {
  user_data_file_name = "${var.linux_distribution == "ubuntu" ? "user_data_ubuntu.tmpl" : "user_data_amazonlinux.tmpl"}"

}
