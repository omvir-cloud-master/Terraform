module "my_vpc" {
  # The relative path to the child module folder
  source = "./modules/vpc"

  # Pass any required input variables expected by the child module
  # bucket_name = "my-unique-storage-bucket-name"
  # environment = "production"
}



# resource "aws_key_pair" "dev-auth" {
#   key_name   = "dev-keypair"
#   public_key = file("~/.ssh/dev-keypair.pub")
# }

# resource "aws_instance" "dev_server" {
#   ami                    = "ami-02b8269d5e85954ef"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.dev_public_sub.id
#   vpc_security_group_ids = [aws_security_group.dev_sg.id]
#   key_name               = aws_key_pair.dev-auth.id
#   user_data              = file("userdata.tpl")

#   root_block_device {
#     volume_size = 10
#     volume_type = "gp3"
#   }

#   tags = {
#     Name = "dev-vm-tf"
#     Env  = "dev"
#   }



# }