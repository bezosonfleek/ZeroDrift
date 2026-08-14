output "instance_details" {
    value = {
        name      = module.compute.instance_name
        public_ip = module.compute.instance_public_ip
    }
}

output "ssh_connection_command" {
  value       = "ssh -i ~/.ssh/zerodrift-key ubuntu@${module.compute.instance_public_ip}"
}