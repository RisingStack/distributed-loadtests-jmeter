output "primary_address" {
  value = digitalocean_droplet.primary.ipv4_address
}

output "runner_addresses" {
  value = [digitalocean_droplet.runner.*.ipv4_address]
}
