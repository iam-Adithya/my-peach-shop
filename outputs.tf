output "public_ipv4" {
  description = "Public IPv4 address of the deployed website."
  value       = linode_instance.peach_shop.ip_address
}

output "website_url" {
  description = "Open this URL after cloud-init finishes installing Nginx (usually 2–5 minutes)."
  value       = "http://${linode_instance.peach_shop.ip_address}"
}

output "login_url" {
  description = "Peach-themed Supabase login page."
  value       = "http://${linode_instance.peach_shop.ip_address}/login.html"
}
