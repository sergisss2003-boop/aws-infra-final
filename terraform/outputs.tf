output "alb_dns_name" {
  description = "DNS del Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_url" {
  description = "URL de la aplicación"
  value       = "http://${aws_lb.main.dns_name}"
}

output "db_endpoint" {
  description = "Endpoint de la base de datos"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "db_replica_endpoint" {
  description = "Endpoint de la réplica de la base de datos"
  value       = aws_db_instance.replica.address
  sensitive   = true
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs de las subredes privadas"
  value       = aws_subnet.private[*].id
}