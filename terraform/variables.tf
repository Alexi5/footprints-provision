variable "public_key_path" {
  type        = "string"
  description = <<EOF
Path to the SSH public key to be used for authentication.
Create this SSH keypair BEFORE provisioning or you will not be able to connect.
Ensure this keypair is added to your local SSH agent so provisioners can connect.
Example: ~/.ssh/id_rsa.pub
EOF
}

variable "private_key_path" {
  type        = "string"
  description = <<EOF
Path to the SSH private key to be used for authentication.
Create this SSH keypair BEFORE provisioning or you will not be able to connect.
Ensure this keypair is added to your local SSH agent so provisioners can connect.
Example: ~/.ssh/id_rsa
EOF
}

variable "db_username" {
  type = "string"
  description = <<EOF
The username for the Footprints production database.
Whatever you specify here will be passed to Ansible in order to populate the
Rails database.yml config file when provisioning the EC2 instances.
EOF
}

variable "db_password" {
  type = "string"
  description = <<EOF
The password for the Footprints production database.
Whatever you specify here will be passed to Ansible in order to populate the
Rails database.yml config file when provisioning the EC2 instances.
EOF
}