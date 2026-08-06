# #####################################
# # Backend EC2
# #####################################

resource "aws_instance" "backend" {
  count                  = 2
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t2.micro"
  tenancy                = "default"
  subnet_id              = var.priv_subnet_ids[count.index]
  vpc_security_group_ids = [var.backend_security_group_id]
  tags = {
    Name = "backend-ec2-${var.environment}-${count.index + 1}"
  }
}






