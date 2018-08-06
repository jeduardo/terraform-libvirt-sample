# terraform-libvirt-sample

A small collection of terraform files used to provision virtual machines onto a
libvirt hypervisor.

## Overview

The following items are covered:

* volumes: manages the current volumes present in the libvirt hypervisor.

* network: manages the networks deployed onto the libvirt hypervisor.

* mongo: manages a collection of mongodb machines deployed onto the hypervisor.
  It depends on the `network` and `volumes` already managed with terraform.

## Execution

To execute the modules, install the [terraform libvirt
plugin](https://github.com/dmacvicar/terraform-provider-libvirt) onto your
terraform installation and run the usual `terraform plan` and `terraform apply`
inside each of the subdirectories.
