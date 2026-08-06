output "instance_ids" {
  value = aws_instance.frontend[*].id
}