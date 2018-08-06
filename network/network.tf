# Basic setup

terraform {
  backend "local" {
    path = "network.tfstate"
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}

# Input variables

## NONE

# Resources

resource "libvirt_network" "dev-infra" {
  name = "dev-infra"
  mode = "nat"
  domain = "dev.infra.network"
  addresses = ["172.16.10.0/24"]
  autostart = "true"
}

# Output variables

output "network_id" {
  value = "${libvirt_network.dev-infra.id}"
}

output "network_name" {
  value = "${libvirt_network.dev-infra.name}"
}