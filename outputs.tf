output "name" {
  value = hcloud_load_balancer.lb.name
}

output "ipv4_address" {
  value = hcloud_load_balancer.lb.ipv4
}

output "ipv6_address" {
  value = hcloud_load_balancer.lb.ipv6
}

output "id" {
  value = hcloud_load_balancer.lb.id
}

output "type" {
  value = hcloud_load_balancer.lb.load_balancer_type
}
