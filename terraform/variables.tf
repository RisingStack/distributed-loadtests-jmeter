variable "do_token" {
  type        = string
  description = "Your DigitalOcean API token"
}

variable "droplet_image" {
  type = string
  description = "OS AMI"
  default= "centos-7-x64"
}

variable "droplet_size" {
  type = string
  description = "Size of the droplet"
  default= "s-2vcpu-2gb"
}

variable "region" {
  type = string
  description = "DO region | default Frankfurt"
  default = "fra1"
}

variable "primary_name" {
  type = string
  description = "Name of the server that will coordinate the tests"
  default = "load-test-primary"
}

variable "runner_name" {
  type = string
  description = "Name of the server that will run the tests"
  default = "load-test-runner"
}

variable "ssh_key_name" {
  type = string
  description = "Name of the ssh key"
  default = "load-test-ssh"
}

variable "ssh_user" {
  type = string
  description = "Root user name"
  default = "root"
}

variable "ssh_root_pub_key_path" {
  type = string
  description = "Public key path of the root user"
  default = "ssh/root.pub"
}

variable "ssh_root_private_key_path" {
  type = string
  description = "Private key path of the root user"
  default = "ssh/root"
}

variable "non_root_user" {
  type = string
  description = "Name of the default non-root user"
  default = "runner"
}

variable "non_root_user_password" {
  type = string
  description = "Password of the default non-root user"
  default = "runner"
}

variable "non_root_user_pub_key" {
  type = string
  description = "Public key of the non-root user"
  default = "ssh/runner.pub"
}

variable "non_root_user_private_key" {
  type = string
  description = "Private key of the non-root user"
  default = "ssh/runner"
}

variable "instance_count" {
  type = number
  default = 2
}
