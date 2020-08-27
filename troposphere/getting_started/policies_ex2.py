from troposphere import Template
from troposphere.iam import Role

from awacs.aws import Allow, Statement, Principal, Policy
from awacs.sts import AssumeRole

t = Template()

t.add_resource(Role(
  'Role2',
  AssumeRolePolicyDocument=Policy(
    Statement=[
      Statement(
        Effect=Allow,
        Action=[AssumeRole],
        Principal=Principal('Service', ['ec2.amazonaws.com'])
      )
    ]
  )
))

print(t.to_yaml())
