terraform {
  required_version = ">= 1.5.0"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 3.10"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

provider "linode" {
  # Reads LINODE_TOKEN from your environment. Do not hard-code API tokens here.
  token = var.linode_token
}

provider "archive" {}

data "archive_file" "site" {
  type        = "zip"
  source_dir  = "${path.module}/site"
  output_path = "${path.module}/site.zip"
}



resource "linode_instance" "peach_shop" {
  label           = var.instance_label
  image           = "linode/ubuntu24.04"
  region          = var.region
  type            = var.instance_type
  root_pass       = var.root_password
  tags            = ["peach-shop", "terraform"]

  metadata {
    user_data = base64encode(templatefile("${path.module}/cloud-init.sh.tftpl", {
      site_zip_base64 = filebase64(data.archive_file.site.output_path)
    }))
  }
}
