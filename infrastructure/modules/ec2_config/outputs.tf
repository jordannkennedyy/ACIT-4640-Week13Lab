output "instance1" {
  value = aws_instance.instance1
}

output "instance2" {
    value = aws_instance.instance2
}

output "instance1_name" {
    value = aws_instance.instance1.tags["Name"]
}

output "instance2_name" {
  value = aws_instance.instance2.tags["Name"]
}

output "instance1_private_ip" {
  value = aws_instance.instance1.private_ip
}

output "instance2_private_ip" {
  value = aws_instance.instance2.private_ip
}