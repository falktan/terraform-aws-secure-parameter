variable "secrets" {
    type = map(string)
    desciption = "Secrets to be added to the AWS parameter store. Keys are the path for the parameter store. Values are secrets encrypted by a KMS-Key."
}