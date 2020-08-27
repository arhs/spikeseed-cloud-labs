from troposphere import Template, Ref, Select, GetAZs
import troposphere.ec2 as ec2

t = Template()

r_vpc = t.add_resource(ec2.VPC(
    'VPC',
    CidrBlock='10.0.0.0/24'
))

r_subnet_az1 = t.add_resource(ec2.Subnet(
  'SubnetAz1',
  CidrBlock='10.0.0.0/25',
  VpcId=Ref(r_vpc),
  AvailabilityZone=Select(0, GetAZs())
))

print(t.to_yaml())
