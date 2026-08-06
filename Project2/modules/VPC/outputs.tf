output "public_subnet_ids" {
  value = aws_subnet.public_sub[*].id
}


output "security_group_id" {
  value = aws_security_group.frontend_sg.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_sub[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_sub[*].id
}

output "backend_security_group_id" {
  value = aws_security_group.backend_sg.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}
