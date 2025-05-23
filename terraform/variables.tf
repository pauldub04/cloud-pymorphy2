variable "api_token" {
  type        = string
  description = "API token для доступа к cloud.mephi.ru"
  sensitive   = true
}

variable "vm_cpu" {
  type        = number
  description = "Количество ядер CPU"
  default     = 4
}

variable "vm_ram" {
  type        = number
  description = "Объем RAM (GB)"
  default     = 4
}

variable "disk_size" {
  type        = number
  description = "Размер системного диска (GB)"
  default     = 10
}