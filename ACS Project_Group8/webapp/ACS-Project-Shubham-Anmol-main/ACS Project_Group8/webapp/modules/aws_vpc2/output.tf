# Add output variables
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "my_vpc_id" {
  value = aws_vpc.smain.id
}

output "prefix" {
  value = var.prefix
}

output "private_subnet_1" {
  value = aws_subnet.private_subnet[0].id
}

output "public_subnet_1" {
  value = aws_subnet.public_subnet[0].id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet[1].id
}

output "availability_zones_1" {
  value = data.aws_availability_zones.available.names[0]
}

output "availability_zones_2" {
  value = data.aws_availability_zones.available.names[1]
}
