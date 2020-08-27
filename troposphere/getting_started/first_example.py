from troposphere import Template
from troposphere import ec2

t = Template()
# r_vpc = t.add_resource(ec2.VPC(
#   'VPC',
#   CidrBlock='10.0.0.0/24'
# ))

r_vpc = ec2.VPC('VPC')
r_vpc.CidrBlock = '10.0.0.0/24'
t.add_resource(r_vpc)

print(t.to_json())
print('------')
print(t.to_yaml())
