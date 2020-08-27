from enum import Enum
import pathlib
import os
from typing import Dict
import boto3
import botocore
from troposphere import Template

class TemplateFormat(Enum):
  JSON = 1
  YAML = 2

def _dict_to_boto3_tag_list(tags_dict: Dict[str, str], tag_name_key_name: str = 'Key', tag_value_key_name: str = 'Value'):
  tags_list = []
  for k, v in tags_dict.items():
    tags_list.append({tag_name_key_name: k, tag_value_key_name: v})

  return tags_list

def _get_cfn_client(profile_name: str = None, region: str = None):
  if profile_name:
    session = boto3.Session(profile_name=profile_name, region_name=region)
    return session.client('cloudformation')

  return boto3.client('cloudformation', region_name=region)

def _stack_exists(cfn_client, stack_name):
  stacks = cfn_client.list_stacks()['StackSummaries']

  for stack in stacks:
    if stack['StackStatus'] == 'DELETE_COMPLETE':
      continue
    if stack_name == stack['StackName']:
      return True

  return False

def generate(template: Template, template_path: str, template_format: TemplateFormat):
  print(f'Generating template: {template_path}')

  pathlib.Path(os.path.dirname(os.path.abspath(template_path))).mkdir(parents=True, exist_ok=True)

  if template_format == TemplateFormat.YAML:
    with open(template_path, 'w') as f:
      f.write(template.to_yaml())
  else:
    with open(template_path, 'w') as f:
      f.write(template.to_json())

def _create_stack(cfn_client, stack_params):
  stack_name = stack_params['StackName']
  print(f'Creating stack: {stack_name}')

  cfn_client.create_stack(**stack_params)
  waiter = cfn_client.get_waiter('stack_create_complete')
  print('...waiting for stack to be created...')
  waiter.wait(StackName=stack_name)
  print(f'Stack created: {stack_name}')

def _update_stack(cfn_client, stack_params):
  stack_name = stack_params['StackName']
  print(f'Updating stack: {stack_name}')
  try:
    cfn_client.update_stack(**stack_params)
    waiter = cfn_client.get_waiter('stack_update_complete')
    print('...waiting for stack to be updated...')
    waiter.wait(StackName=stack_name)
  except botocore.exceptions.ClientError as ex:
    error_message = ex.response['Error']['Message']
    if error_message == 'No updates are to be performed.':
      print(f'No changes for stack {stack_name}')
    else:
      raise
  else:
    print(f'Stack updated: {stack_name}')

def _delete_stack(cfn_client, stack_name):
  print(f'Deleting stack: {stack_name}')

  cfn_client.delete_stack(StackName=stack_name)
  waiter = cfn_client.get_waiter('stack_delete_complete')
  print('...waiting for stack to be deleted...')
  waiter.wait(StackName=stack_name)
  print(f'Stack deleted: {stack_name}')

def deploy(stack_name: str,
           template_path: str,
           template_parameters: Dict[str, str] = None,
           tags: Dict[str, str] = None,
           profile: str = None,
           region: str = None
          ):
  stack_params: Dict = {
    'Capabilities': ['CAPABILITY_IAM', 'CAPABILITY_NAMED_IAM'],
    # 'ClientRequestToken': uuid.uuid4(),
    'StackName': stack_name
  }

  with open(template_path, 'r') as template:
    stack_params['TemplateBody'] = template.read()

  stack_params['Parameters'] = []
  if template_parameters:
    for k, v in template_parameters.items():
      stack_params['Parameters'].append({'ParameterKey': k, 'ParameterValue': v})

  if tags:
    stack_params['Tags'] = _dict_to_boto3_tag_list(tags)

  cfn_client = _get_cfn_client(profile, region)
  stack_exists = _stack_exists(cfn_client, stack_name)

  if not stack_exists:
    _create_stack(cfn_client, stack_params)
  else:
    _update_stack(cfn_client, stack_params)

def undeploy(stack_name: str, profile: str = None, region: str = None):
  cfn_client = _get_cfn_client(profile, region)
  stack_exists = _stack_exists(cfn_client, stack_name)

  if stack_exists:
    _delete_stack(cfn_client, stack_name)
  else:
    print(f'The stack {stack_name} does not exit')
