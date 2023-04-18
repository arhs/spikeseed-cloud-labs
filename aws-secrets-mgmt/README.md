# aws-secrets-mgmt

The code is written in Python 3.8 and uses the libraries *json*, *pathlib* and *boto3*.

Here are the AWS Secrets Manager interaction function snippet you will find in *secrets-mgmt.py* :

- list_secrets: list secrets name for a profile/region given
- list_versions: list versions for a secret
- get_secret_value: displays secret value
- dump_secret: dump secret value in a json file
- create_secret: create a secret from a json file
- update_secret: update a secret from a json file
- delete_secret: delete a secret
