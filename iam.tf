########   IAM Role & Policy #############

resource "aws_iam_policy" "discover_ec2" {
  name        = "${var.cluster_name}_discover_ec2_policy-${random_id.cluster_id.hex}"
  description = "for couchbase discover"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TerraformCreator",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "get_s3_repo_bucket" {
  name        = "${var.cluster_name}_s3_read_repo_bucket-${random_id.cluster_id.hex}"
  description = "for ansible repo"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "TerraformCreator",
            "Effect": "Allow",
            "Action": "s3:Get*",
            "Resource": ["arn:aws:s3:::dima-ansible-modules",
                         "arn:aws:s3:::dima-ansible-modules/*"]
        }
    ]
}
EOF
}

resource "aws_iam_role" "ec2_couchbase_nodes_role" {
  name = "${var.cluster_name}_role-${random_id.cluster_id.hex}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "couchbase_discover_attach" {
  name = "couchbase_discover_attachment"
  policy_arn = aws_iam_policy.discover_ec2.arn
  roles = ["${aws_iam_role.ec2_couchbase_nodes_role.name}"]
}

resource "aws_iam_policy_attachment" "s3_ansible_repo_attach" {
  name = "couchbase_s3_ansible_repo_attach"
  policy_arn = aws_iam_policy.get_s3_repo_bucket.arn
  roles = ["${aws_iam_role.ec2_couchbase_nodes_role.name}"]
}


resource "aws_iam_instance_profile" "couchbase_discover_ec2_profile" {
  name = "${var.cluster_name}-discover_ec2_profile-${random_id.cluster_id.hex}"
  role = aws_iam_role.ec2_couchbase_nodes_role.name
}
