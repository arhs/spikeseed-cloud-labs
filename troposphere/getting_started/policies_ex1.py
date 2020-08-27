from troposphere import Template
from troposphere.iam import Role

t = Template()

t.add_resource(Role(
  'Role1',
  AssumeRolePolicyDocument={
    'Statement': [
      {
        'Principal': {
          'Service': [
            'ec2.amazonaws.com'
          ]
        },
        'Effect': 'Allow',
        'Action': [
          'sts:AssumeRole'
        ]
      }
    ]
  }
))

print(t.to_yaml())
