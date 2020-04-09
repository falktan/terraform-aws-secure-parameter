data "aws_kms_secrets" "secrets" {
  count = length(var.secrets) == 0 ? 0:1

  dynamic "secret" {
    for_each = var.secrets

    content {
      name = secret.key
      payload = secret.value
    }
  }
}

resource "aws_ssm_parameter" "secrets" {
  for_each = length(var.secrets) == 0 ? {} : data.aws_kms_secrets.secrets[0].plaintext

  name = each.key
  value = each.value
  type = "SecureString"
}
