output "security_group_id" {
  value = aws_security_group.zero-drift-sg.id
}
output "subnet_id" {
  value = aws_subnet.zero-drift-pub-subnet.id
}