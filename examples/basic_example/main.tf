resource "aws_kms_key" "code_credentials" {
}

resource "aws_kms_alias" "code_credentials" {
  name = "alias/code_credentials_kms"
  target_key_id = aws_kms_key.code_credentials.key_id
}

module "secure_parameter" {
  source = "../../"
  secrets = jsondecode(file("secrets.json"))
}
