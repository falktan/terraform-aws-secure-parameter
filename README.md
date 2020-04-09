# Terraform AWS Secure Parameter
This is a terraform module to simplify handling of credentials in terraform that shall be made available in the AWS parameter store.

While storing credentials in AWS parameter store in an encrypted manner is easy, provisioning such credentials in terraform is cumbersome. It should be avoided to have unencrypted credentials as part of any kind of source code. This also applies to terraform templates.

A simple workaround is to pass credentials as parameters when applying a terraform template. However, this is still inconvenient. In addition it does not solve the problem of distributing the secrets among several developers and also does not scale well with an increasing number of credentials.

This module solves those problem by the following strategy:
A KMS-Key is generated, which is used to encrypt credentials. Only those encrypted credentials are stored with the terrerform templates.
Then this module is used. It decrypts those credentials during ```terraform apply``` and stores them in the parameter store.

## Usage
To use this module, create a KMS-Key and decrypt any needed credentials with it. Those credentials can then be stored in the terraform template like this
```
module "secure_parameter" {
  source = "github.com/falktan/terraform-aws-secure-parameter.git"
  secrets = {
    "path/to/admin_password" = "<kms encrypted password>",
    "path/to/another_password" = "<another kms encrypted password>"
  }
}
```
where ```path/to/``` is the desired path in the parameter store in AWS. This provides the credentials as encrypted parameters in the AWS parameter store.
To be secure it is ofcause still neccessary to limit access to the parameter store through appropriate policies. As always, consider the terraform state itself secret and make sure access to it is limited appropriately.
