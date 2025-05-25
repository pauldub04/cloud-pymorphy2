output "app_ip" {
  value       = rustack_vm.morph_backend.floating_ip
  description = "Публичный IP адрес приложения"
}
