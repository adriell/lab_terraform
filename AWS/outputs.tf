#---- Strorage outputs ----#

output "bucket_name" {
  value = "${module.storage.bucketname}"
}

#---- Network outputs ----#
output "Public subnets" {
  value = "${join(",",module.networking.public_subnets)}"
}

output "Subnet IPs" {
  value = "${join(",", module.networking.subnet_ips)}"
}

output "Public Security Group" {
  value = "${module.networking.public_sg}"
}

#---- Compute outputs -----#

output "Pucblic Instances IDs" {
  value = "${module.compute.server_id}"
}

output "Public Instance IPs" {
  value = "${module.compute.server_ip}"
}
