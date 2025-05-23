data "rustack_vdc" "morph" {
  name          = "Morphology"
  project_id    = data.rustack_project.project.id
}

data "rustack_network" "morph_network" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "Сеть"
}

data "rustack_template" "morph_ubuntu20" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "Ubuntu 20.04"
}

data "rustack_storage_profile" "morph_ssd" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "ssd"
}

data "rustack_firewall_template" "morph_allow_ingress" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "Разрешить входящие"
}

data "rustack_firewall_template" "morph_allow_egress" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "Разрешить исходящие"
}

data "rustack_firewall_template" "morph_web" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "Разрешить WEB"
}

data "rustack_firewall_template" "morph_ssh" {
  vdc_id = data.rustack_vdc.morph.id
  name   = "Разрешить SSH"
}

resource "rustack_port" "morph_port" {
  vdc_id     = data.rustack_vdc.morph.id
  network_id = data.rustack_network.morph_network.id
#   ip_address = "10.0.1.20"
  firewall_templates = [
    data.rustack_firewall_template.morph_allow_ingress.id,
    data.rustack_firewall_template.morph_allow_egress.id,
    data.rustack_firewall_template.morph_web.id,
    data.rustack_firewall_template.morph_ssh.id,
  ]
}

resource "rustack_vm" "morph_vm" {
  vdc_id      = data.rustack_vdc.morph.id
  name        = "morph_vm"
  cpu         = var.vm_cpu
  ram         = var.vm_ram
  floating    = true
  template_id = data.rustack_template.morph_ubuntu20.id

  user_data = templatefile("${path.module}/cloud-init/morph.yaml", {
    docker_compose = filebase64("${path.module}/../docker-compose.yml")
    nginx_conf = filebase64("${path.module}/../nginx.conf")
    index_html = filebase64("${path.module}/../frontend/index.html")
    script_js = filebase64("${path.module}/../frontend/script.js")
  })

  system_disk {
    size               = var.disk_size
    storage_profile_id = data.rustack_storage_profile.morph_ssd.id
  }

  networks {
    id = rustack_port.morph_port.id
  }

  lifecycle {
    # prevent_destroy = true
    # ignore_changes  = [user_data]
  }
}
