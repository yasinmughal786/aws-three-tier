
# Find a current Amazon Linux 2023 AMI
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Private EC2 application server
resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.app.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd
    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html>
      <head><title>Secure Three-Tier Application</title></head>
      <body>
        <h1>Secure Three-Tier Application</h1>
        <p>Application server is running in a private subnet.</p>
        <p>Access is provided through the Application Load Balancer.</p>
      </body>
    </html>
    HTML
  EOF

  tags = {
    Name = "${var.project_name}-app-server"
  }
}
