# Basic Setup

terraform {
  backend "local" {
    path = "volumes.tfstate"
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}


# Input variables

## NONE

# Resources

resource "libvirt_volume" "debian9-base" {
  name = "debian9-base.qcow2"
  source = "http://localhost:8000/debian9-uefi.qcow2"
}

# Output variables

output "debian9_id" {
  value = "${libvirt_volume.debian9-base.id}"
}
