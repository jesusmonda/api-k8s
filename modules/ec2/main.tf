resource "aws_instance" "rancher" {
  ami             = "ami-089cc16f7f08c4457"
  instance_type   = "t2.medium"
  subnet_id       = var.subnet_public1_id
  security_groups = [var.sg_rancher_id]
  user_data       = file("../../modules/ec2/rancher.sh")

  tags = {
    Name = "${var.branch}:${var.environment}:rancher-server"
  }
}