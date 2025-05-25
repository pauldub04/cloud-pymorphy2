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
  firewall_templates = [
    data.rustack_firewall_template.morph_allow_ingress.id,
    data.rustack_firewall_template.morph_allow_egress.id,
    data.rustack_firewall_template.morph_web.id,
    data.rustack_firewall_template.morph_ssh.id,
  ]
}

resource "rustack_vm" "morph_backend" {
  vdc_id      = data.rustack_vdc.morph.id
  name        = "morph_backend"
  cpu         = var.vm_cpu
  ram         = var.vm_ram
  floating    = true
  template_id = data.rustack_template.morph_ubuntu20.id

  user_data = templatefile("${path.module}/cloud-init/morph.yaml", {})

  system_disk {
    size               = var.disk_size
    storage_profile_id = data.rustack_storage_profile.morph_ssd.id
  }

  networks {
    id = rustack_port.morph_port.id
  }
}

curl -sfL https://get.k3s.io | K3S_URL="https://10.0.0.3:6443" \
K3S_TOKEN="K1000e0c56c69eaebd1b12717ed3d93f1e8de5473c18172511e3d1a4eaa957576a1::server:e69016174d30a186e92d27a3db790012" \
K3S_KUBECONFIG_MODE="644" \
sh -