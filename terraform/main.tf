resource "digitalocean_ssh_key" "default" {
  name       = var.ssh_key_name
  public_key = file(var.ssh_root_pub_key_path)
}

resource "digitalocean_droplet" "runner" {
  count = var.instance_count
  image  = var.droplet_image
  name   = "${var.runner_name}-${count.index + 1}"
  region = var.region
  size   = var.droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  provisioner "remote-exec" {
    inline = ["echo 'Waiting for connection...'"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_root_private_key_path)
    }
  }
  provisioner "local-exec" {
    command = <<EOT
    export ANSIBLE_HOST_KEY_CHECKING=False
    ansible-playbook -i '${self.ipv4_address},' --private-key ${var.ssh_root_private_key_path} --user ${var.ssh_user} -e 'user=${var.non_root_user} user_pw=${var.non_root_user_password} user_public_key="${file(var.non_root_user_pub_key)}"' ../ansible/create-user.yml
    ansible-playbook -i '${self.ipv4_address},' --private-key ${var.non_root_user_private_key} --user ${var.non_root_user} -e 'slave=true' ../ansible/jmeter.yml
    EOT
  }
}

resource "digitalocean_droplet" "primary" {
  image  = var.droplet_image
  name   = var.primary_name
  region = var.region
  size   = var.droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  provisioner "remote-exec" {
    inline = ["echo 'Waiting for connection...'"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_root_private_key_path)
    }
  }
  provisioner "local-exec" {
    command = <<EOT
    export ANSIBLE_HOST_KEY_CHECKING=False
    ansible-playbook -i '${self.ipv4_address},' --private-key ${var.ssh_root_private_key_path} --user ${var.ssh_user} -e 'user=${var.non_root_user} user_pw=${var.non_root_user_password} user_public_key="${file(var.non_root_user_pub_key)}"' ../ansible/create-user.yml
    ansible-playbook -i '${self.ipv4_address},' --private-key ${var.non_root_user_private_key} --user ${var.non_root_user} -e 'remote_hosts="${join(",", digitalocean_droplet.runner.*.ipv4_address)}"' ../ansible/jmeter.yml
    EOT
  }
}
