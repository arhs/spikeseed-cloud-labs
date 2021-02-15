import sys
import boto3

class SsmParameterUpdater:

  def __init__(self, profile_name, region_name):
    if len(sys.argv) == 2 and sys.argv[1] == '--nodryrun':
      self._dry_run = False
      print('==================')
      print('Update Mode')
      print('==================')
    else:
      self._dry_run = True
      print('==================')
      print('Dry Run Mode')
      print('==================')
    session = boto3.Session(profile_name=profile_name, region_name=region_name)
    self._ssm_client = session.client('ssm')

  def get_ssm_parameter(self, name: str):
    try:
      return self._ssm_client.get_parameter(Name=name, WithDecryption=True)['Parameter']
    except:
      return None

  def put_ssm_parameter(self, name: str, value: str, value_type: str = 'SecureString'):
    param = self.get_ssm_parameter(name)
    if not param or param['Value'] != value or param['Type'] != value_type:
      if not self._dry_run:

        self._ssm_client.put_parameter(
          Name=name,
          Value=value,
          Type=value_type,
          Overwrite=True
        )

        print(f'[modified] {name}')

      else:
        print(f'DR - [modified] {name}')
    elif not self._dry_run:
      print(f'[no change] {name}')
    else:
      print(f'DR - [no change] {name}')
