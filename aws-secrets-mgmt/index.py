import json
import boto3
import sys


### Variables to edit ###
AWS_PROFILE = 'my-profile'
AWS_REGION =  'eu-west-1'
KMS_KEY_ALIAS = 'alias/my-kms-key'

# Create a boto3 session
AWS_SESSION = boto3.session.Session(profile_name=AWS_PROFILE, region_name=AWS_REGION)
SM_CLIENT = AWS_SESSION.client('secretsmanager')


def read_json_file(filepath):
    with open(filepath) as f:
        return json.load(f)


def write_json_file(filename, data):
    with open(filename, 'w') as f:
        json.dump(data, f, indent=4)


def list_secrets(sm_client):
    secrets = []
    continuation_token = None

    while True:
        list_kwargs = dict()
        if continuation_token:
            list_kwargs['NextToken'] = continuation_token

        sm_response = sm_client.list_secrets(**list_kwargs)
        for secret in sm_response['SecretList']:
            name = secret['Name']
            created_date = secret['CreatedDate'].strftime("%m/%d/%Y %H:%M:%S")
            modified_date = secret['LastChangedDate'].strftime("%m/%d/%Y %H:%M:%S")
            deleted_date = secret['DeletedDate'].strftime("%m/%d/%Y %H:%M:%S") if 'DeletedDate' in secret else ''

            secrets.append([name, created_date, modified_date, deleted_date])

        continuation_token = sm_response.get('NextToken')
        if not continuation_token:
            break

    secrets.sort(key=lambda x:x[0])
    print(secrets)


def list_versions(sm_client, secret_name):
    versions = []
    continuation_token = None

    while True:
        list_kwargs = {'SecretId': secret_name}
        if continuation_token:
            list_kwargs['NextToken'] = continuation_token

        sm_response = sm_client.list_secret_version_ids(**list_kwargs)
        for version in sm_response['Versions']:
            version_id = version['VersionId']
            created_date = version['CreatedDate'].strftime("%m/%d/%Y, %H:%M:%S")
            last_accessed_date = version['LastAccessedDate'].strftime("%m/%d/%Y, %H:%M:%S") if 'LastAccessedDate' in version else ''

            versions.append([secret_name, version_id, created_date, last_accessed_date])

        continuation_token = sm_response.get('NextToken')
        if not continuation_token:
            break
    print(versions)


def get_secret_value(sm_client, secret_name, version):
    list_kwargs = {'SecretId': secret_name}
    if version != 'latest':
        list_kwargs['VersionId'] = version

    secret = sm_client.get_secret_value(**list_kwargs)['SecretString']
    return json.loads(secret)


def dump_secret(sm_client, profile, region, secret_name, version):
    secret_json = get_secret_value(sm_client, secret_name, version)
    filename = f'secret.{profile}-{region}-{secret_name}.{version}.json'
    write_json_file(filename, secret_json)


def create_secret(sm_client, secret_name, filepath, kms_key):
    json_obj = read_json_file(filepath)

    response = sm_client.create_secret(
        Name=secret_name,
        KmsKeyId=kms_key,
        SecretString=json.dumps(json_obj)
    )

    if response['VersionId']:
        print(f'Secret {secret_name} created successfuly')
    else:
        print(f'Issue while creating the Secret {secret_name}')


def update_secret(sm_client, secret_name, filepath, kms_key):
    json_obj = read_json_file(filepath)

    response = sm_client.update_secret(
        SecretId=secret_name,
        KmsKeyId=kms_key,
        SecretString=json.dumps(json_obj)
    )

    if response['VersionId']:
        print(f'Secret {secret_name} updated successfuly')
    else:
        print(f'Issue while updating the Secret {secret_name}')


def delete_secret(sm_client, secret_name):
    response = sm_client.delete_secret(
        SecretId=secret_name,
        ForceDeleteWithoutRecovery=True
    )

    if response['DeletionDate']:
        print(f'Secret {secret_name} deleted successfuly')
    else:
        print(f'Issue while deleting the Secret {secret_name}')

if __name__ == '__main__':
    action = sys.argv[1]
    if action == 'list':
        list_secrets(SM_CLIENT)
    elif action == 'list-versions':
        secret_name = sys.argv[2]
        list_versions(SM_CLIENT, secret_name)
    elif action == 'get':
        secret_name = sys.argv[2]
        secret_version = sys.argv[3]
        print(get_secret_value(SM_CLIENT, secret_name, secret_version))
    elif action == 'dump':
        secret_name = sys.argv[2]
        secret_version = sys.argv[3]
        dump_secret(SM_CLIENT, AWS_PROFILE, AWS_REGION, secret_name, secret_version)
    elif action == 'create':
        secret_name = sys.argv[2]
        filepath = sys.argv[3]
        create_secret(SM_CLIENT, secret_name, filepath, KMS_KEY_ALIAS)
    elif action == 'update':
        secret_name = sys.argv[2]
        filepath = sys.argv[3]
        update_secret(SM_CLIENT, secret_name, filepath, KMS_KEY_ALIAS)
    elif action == 'delete':
        secret_name = sys.argv[2]
        security = input(f'Are you sure you want to delete the secret {secret_name}? (y/n): ')
        if security == 'y' or security == 'Y':
            secret_name = sys.argv[2]
            delete_secret(SM_CLIENT, secret_name)
    else:
        print('Invalid action')
