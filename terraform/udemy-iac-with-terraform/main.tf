provider "aws" {
  profile = "kzmshx_aws_test-terraform"
  region  = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  # https://ap-northeast-1.console.aws.amazon.com/ec2/home?region=ap-northeast-1#AMICatalog:
  ami           = "ami-0a2e10c1b874595a1"
  instance_type = "t2.micro"

  tags = {
    Name = "hello-world"
  }

  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1.12
systemctl start nginx
EOF
}
