variable "public_key_path" {
  type        = "string"
  default     = "~/.ssh/mongeese-footprints.pub"
  description = <<EOF
Path to the SSH public key to be used for authentication.
Create this SSH keypair BEFORE provisioning or you will not be able to connect.
Ensure this keypair is added to your local SSH agent so provisioners can connect.
Example: ~/.ssh/id_rsa.pub
EOF
}

variable "private_key_path" {
  type        = "string"
  default     = "~/.ssh/mongeese-footprints"
  description = <<EOF
Path to the SSH private key to be used for authentication.
Create this SSH keypair BEFORE provisioning or you will not be able to connect.
Ensure this keypair is added to your local SSH agent so provisioners can connect.
Example: ~/.ssh/id_rsa
EOF
}

variable "staging_ec2_id" {
  type = "string"
  description = "The EC2 Instance connected to staging ELB."
}

variable "production_ec2_id" {
  type = "string"
  description = "The EC2 instance connected to production ELB."
}

data "vault_generic_secret" "db_credentials" {
  path = "secret/production_db"
}

data "vault_generic_secret" "omniauth" {
  path = "secret/omniauth"
}