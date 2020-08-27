from troposphere import Template, Equals, Ref
from troposphere import ec2

t = Template()

c_is_prod = t.add_condition('IsProduction', Equals(Ref('Environment'), 'true'))

t.add_resource(ec2.VPC(
  'VPC',
  Condition=c_is_prod,
  CidrBlock='10.0.0.0/24'
))

print(t.to_json())
