output "instance_name" {
    value = aws_instance.zero-drift-instance.tags["Name"]
}

output "instance_public_ip" {
    value = aws_instance.zero-drift-instance.public_ip
}