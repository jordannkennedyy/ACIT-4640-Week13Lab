output "subnet1" {
    value = aws_subnet.subnet1
}

output "subnet2" {
    value = aws_subnet.subnet2
}

output "main_vpc" {
    value = aws_vpc.main
}

output "main_security_group"{
    value = aws_security_group.main.id
}

