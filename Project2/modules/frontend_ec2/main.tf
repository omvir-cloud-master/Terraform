# #####################################
# # Frontend EC2
# #####################################

resource "aws_instance" "frontend" {
  count                  = 2
  ami                    = "ami-0b6d9d3d33ba97d99"
  instance_type          = "t2.micro"
  tenancy                = "default"
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.frontend_key.key_name
  user_data = templatefile("${path.module}/user_data.sh", {
    server_number = count.index + 1
  })



  tags = {
    Name = "frontend-ec2-${var.environment}-${count.index + 1}"
  }
}






