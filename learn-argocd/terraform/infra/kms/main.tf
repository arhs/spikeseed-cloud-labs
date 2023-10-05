resource "aws_kms_key" "this" {
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = var.deletion_window_in_days
  description              = var.description
  enable_key_rotation      = var.enable_key_rotation
  is_enabled               = var.is_enabled
  key_usage                = "ENCRYPT_DECRYPT"
  policy                   = var.policy
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.key_name}"
  target_key_id = aws_kms_key.this.key_id
}


