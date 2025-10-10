resource "aws_instance" "main" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = element(var.subnet_ids, count.index)
  
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.enable_monitoring
  ebs_optimized              = var.ebs_optimized
  
  user_data = var.user_data
  
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = var.encrypt_root_volume
    delete_on_termination = var.delete_root_on_termination
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      volume_size           = ebs_block_device.value.volume_size
      encrypted             = ebs_block_device.value.encrypted
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  tags = merge(
    {
      Name = "${var.project_id}-${var.instance_name}-${var.environment}-${count.index + 1}-${data.aws_availability_zones.available.names[count.index]}"
    },
    var.tags
  )
}

resource "aws_eip" "main" {
  count    = var.create_eip ? var.instance_count : 0
  instance = aws_instance.main[count.index].id
  domain   = "vpc"

  tags = merge(
    {
      Name = "${var.instance_name}-eip-${count.index + 1}"
    },
    var.tags
  )
}