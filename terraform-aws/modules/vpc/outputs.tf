output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private_2.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_1_id" {
  description = "Private Route Table 1 ID"
  value       = aws_route_table.private_1.id
}

output "private_route_table_2_id" {
  description = "Private Route Table 2 ID"
  value       = aws_route_table.private_2.id
}

output "nat_gateway_1_id" {
  description = "NAT Gateway 1 ID"
  value       = aws_nat_gateway.nat_1.id
}

output "nat_gateway_2_id" {
  description = "NAT Gateway 2 ID"
  value       = aws_nat_gateway.nat_2.id
}