# -----------------------------------------------------------------------------
# CloudGuard EC2
#
# Both instances are deployed in a private subnet:
# - no public IPv4 address
# - no inbound SSH
# - administration through AWS Systems Manager
# - encrypted EBS root volumes
# - IMDSv2 required
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Latest Amazon Linux 2023 x86_64 AMI
#
# AWS maintains this public SSM parameter and updates it to reference the latest
# Amazon Linux 2023 AMI available in the selected region.
# -----------------------------------------------------------------------------

data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# -----------------------------------------------------------------------------
# Application bootstrap
#
# This is intentionally a small demonstration service.
# It will later be replaced by the actual CloudGuard application deployment.
# -----------------------------------------------------------------------------

locals {
  app_user_data = <<-USERDATA
    #!/bin/bash
    set -euxo pipefail

    install -d -m 0755 /opt/cloudguard-app

    cat > /opt/cloudguard-app/server.py <<'PYTHON'
    from http.server import BaseHTTPRequestHandler, HTTPServer
    import json
    import socket

    class CloudGuardHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path == "/health":
                body = {
                    "status": "healthy",
                    "service": "cloudguard-app",
                    "hostname": socket.gethostname()
                }
                self.send_response(200)
            else:
                body = {
                    "message": "CloudGuard application tier is running",
                    "service": "cloudguard-app"
                }
                self.send_response(200)

            payload = json.dumps(body).encode("utf-8")

            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)

        def log_message(self, format, *args):
            print(
                "%s - - [%s] %s"
                % (
                    self.client_address[0],
                    self.log_date_time_string(),
                    format % args
                )
            )

    HTTPServer(("0.0.0.0", 8080), CloudGuardHandler).serve_forever()
    PYTHON

    cat > /etc/systemd/system/cloudguard-app.service <<'SERVICE'
    [Unit]
    Description=CloudGuard demonstration application
    Wants=network-online.target
    After=network-online.target

    [Service]
    Type=simple
    User=ec2-user
    Group=ec2-user
    WorkingDirectory=/opt/cloudguard-app
    ExecStart=/usr/bin/python3 /opt/cloudguard-app/server.py
    Restart=always
    RestartSec=5
    NoNewPrivileges=true
    PrivateTmp=true
    ProtectSystem=strict
    ProtectHome=true
    ReadWritePaths=/opt/cloudguard-app

    [Install]
    WantedBy=multi-user.target
    SERVICE

    chown -R ec2-user:ec2-user /opt/cloudguard-app

    systemctl daemon-reload
    systemctl enable --now cloudguard-app.service
  USERDATA
}

# -----------------------------------------------------------------------------
# Application EC2 instance
# -----------------------------------------------------------------------------

resource "aws_instance" "app" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = var.app_instance_type

  subnet_id                   = aws_subnet.private[0].id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  iam_instance_profile = aws_iam_instance_profile.app_ec2.name

  monitoring = false

  user_data                   = local.app_user_data
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    encrypted             = true
    kms_key_id            = aws_kms_key.cloudguard.arn
    volume_type           = "gp3"
    volume_size           = var.app_root_volume_size
    delete_on_termination = true

    tags = {
      Name = "${local.project_name}-ebs-app-root"
      Role = "application"
    }
  }

  tags = {
    Name = "${local.project_name}-ec2-app"
    Role = "application"
  }

  depends_on = [
    aws_iam_role_policy_attachment.app_ssm_core,
    aws_iam_role_policy_attachment.app_cloudwatch_agent,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssmmessages
  ]
}

# -----------------------------------------------------------------------------
# Private administration EC2 instance
#
# No user_data is required because Amazon Linux 2023 includes SSM Agent.
# No inbound Security Group rule and no SSH key pair are configured.
# -----------------------------------------------------------------------------

resource "aws_instance" "admin" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = var.admin_instance_type

  subnet_id                   = aws_subnet.private[0].id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.admin.id
  ]

  iam_instance_profile = aws_iam_instance_profile.admin_ssm.name

  monitoring = false

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    encrypted             = true
    kms_key_id            = aws_kms_key.cloudguard.arn
    volume_type           = "gp3"
    volume_size           = var.admin_root_volume_size
    delete_on_termination = true

    tags = {
      Name = "${local.project_name}-ebs-admin-root"
      Role = "administration"
    }
  }

  tags = {
    Name = "${local.project_name}-ec2-admin"
    Role = "administration"
  }

  depends_on = [
    aws_iam_role_policy_attachment.admin_ssm_core,
    aws_iam_role_policy_attachment.admin_cloudwatch_agent,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssmmessages
  ]
}
