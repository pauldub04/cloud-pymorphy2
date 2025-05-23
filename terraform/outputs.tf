output "app_ip" {
  value       = rustack_vm.morph_vm.floating_ip
  description = "Публичный IP адрес приложения"
}
