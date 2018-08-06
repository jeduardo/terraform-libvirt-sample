# Basic Setup

terraform {
  backend "local" {
    path = "vms.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "local"
  config {
    path = "../network/network.tfstate"
  }
}

data "terraform_remote_state" "volumes" {
  backend = "local"
  config {
    path = "../volumes/volumes.tfstate"
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}


# Input variables

variable "mongo_count" {
  default = 3
}

# Resources

resource "libvirt_volume" "mongo" {
  name = "mongo${count.index + 1}.dev.infra.network.qcow2"
  base_volume_id = "${data.terraform_remote_state.volumes.debian9_id}"
  count = "${var.mongo_count}"
}

resource "libvirt_domain" "domain" {
  count = "${var.mongo_count}"
  name = "mongo${count.index + 1}.dev.infra.network"
  memory = "2048"
  vcpu = 2
  firmware = "/usr/share/OVMF/OVMF_CODE.fd"
  nvram {
    file = "/var/lib/libvirt/qemu/nvram/mongo${count.index + 1}.dev.infra.network_VARS.fd"
    # This here should point to where exactly in the host filesystem
    # the template file can be found
    template = "/srv/virt/templates/debian-stable-uefi_VARS.fd"
  }
  cpu {
    mode = "host-passthrough"
  }
  network_interface {
    network_name = "${data.terraform_remote_state.network.network_name}"
    hostname = "mongo${count.index + 1}.dev.infra.network"
    addresses = ["172.16.10.7${count.index}"]
    mac = "02:5A:F5:5B:5B:5${count.index+1}"
    # wait_for_lease = 1
  }
  disk {
    # Pay attention that here the count index must be the same.
    volume_id = "${element(libvirt_volume.mongo.*.id, count.index)}"
  }
  graphics {
    type = "spice"
    listen_type = "none"
    autoport = "true"
  }
  console {
    type = "pty"
    target_port = "0"
    target_type = "virtio"
  }
}

# Output variables

## NONE
