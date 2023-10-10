#isolated Network for resources
resource "flexibleengine_vpc_v1" "vpc" {
    name = "abdelrhman-vpc"
    cidr = "10.0.0.0/16"
}

#subnet network
resource "flexibleengine_vpc_subnet_v1" "subnet_1" {
    name       = "abdelrhman--subnet"
    cidr       = "10.0.1.0/24"
    gateway_ip = "10.0.1.1"
    vpc_id     = flexibleengine_vpc_v1.vpc.id
}

#security group for the ECS allowing SSH
resource "flexibleengine_networking_secgroup_v2" "secgroup" {
    name        = "abdelrhman-secgroup"
    description = "terraform security group"
}
# rule to allow ssh
resource "flexibleengine_networking_secgroup_rule_v2" "secgroup_rule_1" {
    direction         = "ingress"
    ethertype         = "IPv4"
    protocol          = "tcp"
    port_range_min    = 22
    port_range_max    = 22
    remote_ip_prefix  = "0.0.0.0/0"
    security_group_id = flexibleengine_networking_secgroup_v2.secgroup.id
}
# rule to allow ICMP
resource "flexibleengine_networking_secgroup_rule_v2" "secgroup_rule_2" {
    direction         = "ingress"
    ethertype         = "IPv4"
    protocol          = "icmp"
    remote_ip_prefix  = "0.0.0.0/0"
    security_group_id = flexibleengine_networking_secgroup_v2.secgroup.id
}

# create elastic IPv4 
resource "flexibleengine_vpc_eip" "eip_1" {
    publicip {
        type = "5_bgp"
    }
    bandwidth {
        name       = "abdelrhman-bandwidth"
        size       = 10
        share_type = "PER" #bandwidth is dedicated
    }
}

#key pair for the ECS
resource "flexibleengine_compute_keypair_v2" "keypair" {
    name = "abdelrhman-keypair"
}

# creating ECS instance
resource "flexibleengine_compute_instance_v2" "abdelrhman_instance" {
    name            = "abdelrhman-instance"
    image_name        = "OBS Ubuntu 18.04"
    flavor_name       = "s6.small.1"
    key_pair        = flexibleengine_compute_keypair_v2.keypair.id
    availability_zone = var.az
    network {
        uuid  = flexibleengine_vpc_subnet_v1.subnet_1.id
    }
    security_groups = [flexibleengine_networking_secgroup_v2.secgroup.id]
}

# Associate instance with EIP
resource "flexibleengine_compute_floatingip_associate_v2" "fip_1" {
    floating_ip = flexibleengine_vpc_eip.eip_1.publicip.0.ip_address
    instance_id = flexibleengine_compute_instance_v2.abdelrhman_instance.id
}
