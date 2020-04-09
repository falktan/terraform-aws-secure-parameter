## Simple Example

This example provides a KMS-Key with an alias, uses it to encrypt credentials and then illustrates how these credentials can be added to the parameter store using the module.

### Prerequisites

To run this example an installation of the [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html) (v1) and of [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) > 0.12.0 is needed.

### Usage

Download the souce-code and switch to the example-directory
```
git clone https://github.com/falktan/terraform-aws-secure-parameter.git
cd terraform-aws-secure-parameter/examples/basic_example
```

To run through the example in one go you can simply run
```
./sample_usage.sh
```

Alternatively go through these steps:

Note that initially the file [secrets.json](secrets.json) contains no secrets.
Initilize terraform and run apply a first time. This will only create a KMS-Key and its alias.
```
terraform init
terraform apply
```

The next step is to encrypt your credentials using the AWS-cli.
For example to encrypt "sampleSecret12345" you can run
```
aws kms encrypt --key-id "alias/code_credentials_kms" --query CiphertextBlob --plaintext sampleSecret12345
```

Now edit [secrets.json](secrets.json). It should look like this, where the output of the previous command is added
```
{
  "sample_secret1": "OUTPUT_OF_ENCRYPTION_COMMAND"
}
```

You can repeat the process and add more secrets to this file.
Finally run once again
```
terraform apply
```
to add the new secrets to the parameter store.

Now the parameters are available in the parameter store. To verify this run
```
aws ssm get-parameters --with-decryption \
  --query "Parameters[*].{Name:Name,Value:Value}" \
  --names sample_secret1 sample_secret2
```

Note that running the same commant without decryption, it would provide only an encripted value. It should be noted, that the KMS-Key used to encrypt/decrypt the parameters in the parameter store is the default KMS-Key for the parameter store. The KMS-Key generated explicitly is only used for the encription of the parameters stored in the source-code.

To clean up destroy the created resources and remove the parameters in the secrets.json file
```
terraform destroy
echo '{}' > secrets.json
```
