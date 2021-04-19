import sys
import boto3

class SsmParameterUpdater:


  def __init__(self, project_name, profile_name, region_name):
    self._project_name = project_name
    self._profile_name = profile_name
    self._region_name = region_name
    self._dry_run = not (len(sys.argv) == 2 and sys.argv[1] == '--nodryrun')
    self._check_mode = len(sys.argv) == 2 and sys.argv[1] == '--check'

    session = boto3.Session(profile_name=profile_name, region_name=region_name)
    self._ssm_client = session.client('ssm')

    self._params = []


  def _get_all_ssm_parameters(self):
    next_token = ' '
    ssm_params = {}

    while next_token is not None:
      response = self._ssm_client.get_parameters_by_path(Path='/', Recursive=True, WithDecryption=True, NextToken=next_token)

      for param in response.get('Parameters'):
        param_name = param['Name']
        if param_name.startswith(f'/{self._project_name}') \
            and not param_name.startswith(f'/{self._project_name}/cfn/') \
            and not param_name.startswith(f'/{self._project_name}/cicd/'):
          ssm_params[param['Name']] = {
            'Value': param['Value'],
            'Type': param['Type'],
            'Seen': False
          }

      next_token = response.get('NextToken', None)

    return ssm_params

  def _get_ssm_parameter(self, name: str):
    try:
      return self._ssm_client.get_parameter(Name=name, WithDecryption=True)['Parameter']
    except:
      return None


  def _put_ssm_parameter(self, name: str, value: str, type: str):
    self._ssm_client.put_parameter(
      Name=name,
      Value=value,
      Type=type,
      Overwrite=True
    )


  def ssm_parameter(self, name: str, value: str, type: str = 'SecureString'):
    self._params.append({
      'Name': name,
      'Value': value,
      'Type': type
    })


  def _execute_dry_run(self):
    print('====================================')
    print(f'Dry Run Mode {self._profile_name} - {self._region_name}')
    print('====================================')
    for expected_param in self._params:
      param_name = expected_param['Name']
      actual_param = self._get_ssm_parameter(param_name)

      if not actual_param or actual_param['Value'] != expected_param['Value'] or actual_param['Type'] != expected_param['Type']:
        print(f'DR - [modified] {param_name}')
      else:
        print(f'DR - [no change] {param_name}')


  def _execute_update_mode(self):
    print('====================================')
    print(f'Update Mode {self._profile_name} - {self._region_name}')
    print('====================================')
    for expected_param in self._params:
      param_name = expected_param['Name']
      actual_param = self._get_ssm_parameter(param_name)

      if not actual_param or actual_param['Value'] != expected_param['Value'] or actual_param['Type'] != expected_param['Type']:
        self._put_ssm_parameter(param_name, expected_param['Value'], expected_param['Type'])
        print(f'[modified] {param_name}')
      else:
        print(f'[no change] {param_name}')


  def _execute_check_mode(self):
    print('====================================')
    print(f'Check Mode {self._profile_name} - {self._region_name}')
    print('====================================')
    actual_params = self._get_all_ssm_parameters()

    for expected_param in self._params:
      param_name = expected_param['Name']
      actual_param = actual_params[param_name] if param_name in actual_params else None

      if not actual_param:
        print(f'Missing parameter: {param_name}')
      elif actual_param['Value'] != expected_param['Value']:
        print(f'Different parameter value: {param_name}')
      elif  actual_param['Type'] != expected_param['Type']:
        print(f'Different parameter type: {param_name}')

      if actual_param:
        actual_param['Seen'] = True

    no_not_seen = True
    for name, param in actual_params.items():
      if not param['Seen']:
        no_not_seen = False
        print(f'Unmanaged parameter: {name}')

    if no_not_seen:
      print('Parameters in sync')


  def execute(self):
    if self._check_mode:
      self._execute_check_mode()
    elif self._dry_run:
      self._execute_dry_run()
    else:
      self._execute_update_mode()
