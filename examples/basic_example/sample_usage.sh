#!/bin/bash -u
set -e  # stop on error

echo "Initializing terraform"
echo "----------------------"
terraform init

echo "Running terraform apply for the first time to create KMS-Key"
echo "----------------------"
terraform apply

echo "Encrypting credentials using aws-cli"
echo "----------------------"
encrypted_secret1=`aws kms encrypt --key-id "alias/code_credentials_kms" --query CiphertextBlob --plaintext sampleSecret12345`
encrypted_secret2=`aws kms encrypt --key-id "alias/code_credentials_kms" --query CiphertextBlob --plaintext asdf12345`

echo \
'{
  "sample_secret1": '$encrypted_secret1',
  "sample_secret2": '$encrypted_secret2'
}' > secrets.json

echo "Running terraform apply for the second time to add created credentials"
echo "----------------------"
terraform apply

echo "Accessing parameter WITHOUT decryption"
aws ssm get-parameters --no-with-decryption \
  --query "Parameters[*].{Name:Name,Value:Value}" \
  --names sample_secret1 sample_secret1

echo "Accessing parameter WITH decryption"
aws ssm get-parameters --with-decryption \
  --query "Parameters[*].{Name:Name,Value:Value}" \
  --names sample_secret1 sample_secret2
