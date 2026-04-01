resource "aws_security_group" "web_sg" {
  name   = "web-security-group"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd

              systemctl start httpd
              systemctl enable httpd

              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html lang="en">
              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Terraform Infrastructure Deployed</title>
                <style>
                  body {
                    margin: 0;
                    font-family: Arial, sans-serif;
                    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
                    color: white;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                  }
                  .card {
                    background: rgba(0, 0, 0, 0.35);
                    padding: 40px;
                    border-radius: 16px;
                    text-align: center;
                    box-shadow: 0 8px 24px rgba(0,0,0,0.3);
                    max-width: 800px;
                  }
                  h1 {
                    font-size: 48px;
                    margin-bottom: 20px;
                  }
                  h2 {
                    font-weight: normal;
                    color: #d1ecf1;
                    margin-bottom: 20px;
                  }
                  .badge {
                    display: inline-block;
                    padding: 10px 20px;
                    background: #22c55e;
                    color: #062e16;
                    border-radius: 999px;
                    font-weight: bold;
                    margin-bottom: 20px;
                  }
                  p {
                    font-size: 18px;
                    line-height: 1.6;
                    color: #f1f5f9;
                  }
                </style>
              </head>
              <body>
                <div class="card">
                  <h1>🚀 Terraform Infrastructure Deployed</h1>
                  <h2>AWS VPC • EC2 • RDS • S3 Remote State</h2>
                  <div class="badge">Infrastructure as Code</div>
                  <p>
                    This environment was provisioned using <strong>Terraform</strong>,
                    following real-world DevOps practices including remote state
                    management and automated provisioning.
                  </p>
                  <p>Built as part of a DevOps Engineer learning project</p>
                </div>
              </body>
              </html>
              HTML
              EOF


  lifecycle {
    ignore_changes = [user_data]
  }
  tags = {
    Name = "terraform-web-instance"
  }
}