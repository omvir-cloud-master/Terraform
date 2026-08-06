resource "aws_key_pair" "frontend_key" {
  key_name   = "frontend-key"
  public_key = file("~/.ssh/frontend-key.pub")
}