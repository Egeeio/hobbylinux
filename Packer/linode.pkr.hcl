packer {
  required_plugins {
    linode = {
      version = ">= 1"
      source  = "github.com/linode/linode"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "linode_api_token" { }

source "linode" "hobbylinux" {
  linode_token      = "${var.linode_api_token}"
  image             = "linode/arch"
  image_description = "Made with Packer"
  image_label       = "HobbyLinux"
  instance_label    = "packer-arch-hobbylinux-builder"
  instance_type     = "g6-nanode-1"
  region            = "us-west"
  ssh_username      = "root"
}

build {
  sources = ["source.linode.hobbylinux"]

  provisioner "shell" {
    inline         = ["pacman --noconfirm -Syyu ansible"]
  }
}
