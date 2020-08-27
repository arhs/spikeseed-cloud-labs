from troposphere import Template
from troposphere import ec2

t = Template()
t.add_resource(ec2.VPC(
  'VPC',
  CidrBlock='10.0.0.0/24'
))

with open('sample.cfn.yml', 'w') as f:
  f.write(t.to_yaml())

with open('sample.json.yml', 'w') as f:
  f.write(t.to_json())
