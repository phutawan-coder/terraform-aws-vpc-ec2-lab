output "app_public_ip" {
  value = module.app.app_public_ip
}

output "db_private_ip" {
  value = module.db.db_private_ip
}
