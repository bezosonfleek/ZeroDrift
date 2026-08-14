data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/resolute/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_instance" "zero-drift-instance" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.zero-drift-key.key_name
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  tags = {
    Name = "${var.project_name}-instance"
  }
}

resource "aws_key_pair" "zero-drift-key" {
  key_name   = "${var.project_name}-ssh-key"
  public_key = var.zero_drift_public_ssh_key
  #public_key = file("~/.ssh/zerodrift-key.pub")
}