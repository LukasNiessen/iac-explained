# Configure the Alibaba Cloud Provider
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.0"
    }
  }
}

provider "alicloud" {
  region = "cn-hangzhou"
}

# Create a VPC
resource "alicloud_vpc" "vpc" {
  vpc_name   = "tf_test_vpc"
  cidr_block = "172.16.0.0/16"
}

# Create an ECS instance
resource "alicloud_instance" "instance" {
  availability_zone = "cn-hangzhou-b"
  security_groups   = [alicloud_security_group.group.id]

  instance_type              = "ecs.n4.large"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "test_system_disk"
  system_disk_description    = "test_system_disk_description"
  image_id                   = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name              = "test_instance"
  vswitch_id                 = alicloud_vswitch.vsw.id
  internet_max_bandwidth_out = 10
}

# Create a security group
resource "alicloud_security_group" "group" {
  name   = "terraform-test-group"
  vpc_id = alicloud_vpc.vpc.id
}