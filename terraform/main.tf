terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

provider "docker" {}

resource "docker_image" "ubuntu" {
    name = "ubuntu:22.04"
    keep_locally = true
}

resource "docker_network" "iac_network" {
    name = "iac_network"
}

resource "docker_container" "ansible_target" {
    image = docker_image.ubuntu.image_id
    name = "ubuntu-ansible-node"

    command = ["sleep", "infinity"]
    networks_advanced {
        name = docker_network.iac_network.name
    }

    ports {
        internal = 80
        external = 8080
    }
}

output "container_name" {
    value = docker_container.ansible_target.name
    description = "The name of the Docker container running the Ansible target"
}

output "container_ip" {
    value = docker_container.ansible_target.network_data[0].ip_address
    description = "The IP address of the Docker container running the Ansible target"
}