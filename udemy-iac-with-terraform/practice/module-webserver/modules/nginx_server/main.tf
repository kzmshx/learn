resource "aws_instance" "server" {
  ami           = "ami-0f89bdd365c3d966d"
  instance_type = var.instance_type
  tags = {
    Name = "test-web-server"
  }
  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1.12
systemctl start nginx
EOF
}
