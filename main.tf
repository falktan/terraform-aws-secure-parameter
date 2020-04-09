data "aws_kms_secrets" "secrets" {
  dynamic "secret" {
    for_each = var.secrets
    name = each.key
    payload = each.value
  }
}

resource "aws_ssm_parameter" "secrets" {
  for_each = data.aws_kms_secrets.secrets.plaintext

  name = each.key
  value = each.value
  type = "SecureString"
}
