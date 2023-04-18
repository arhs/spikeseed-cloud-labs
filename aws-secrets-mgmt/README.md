# aws-secrets-mgmt

The code is written in Python 3.8 and uses the libraries *json*, *boto3* and *sys*.
Do not forget to edit the variables *AWS_PROFILE*, *AWS_REGION* and *KMS_KEY_ALIAS* in the script to match your AWS account.

Here are the AWS Secrets Manager interaction function snippet you will find in *secrets-mgmt.py* :

- list_secrets: list secrets name for a profile/region given
- list_versions: list versions for a secret
- get_secret_value: displays secret value
- dump_secret: dump secret value in a json file
- create_secret: create a secret from a json file
- update_secret: update a secret from a json file
- delete_secret: delete a secret

Here below are some examples of how to use the script:

```bash
python secrets-mgmt.py list
python secrets-mgmt.py list-versions my_secret
python secrets-mgmt.py get my_secret latest
python secrets-mgmt.py dump my_secret latest
python secrets-mgmt.py create my_new_secret secret.json
python secrets-mgmt.py update my_new_secret secret.json
python secrets-mgmt.py delete my_new_secret
```
