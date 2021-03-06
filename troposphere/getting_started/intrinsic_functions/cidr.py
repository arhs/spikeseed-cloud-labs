from troposphere import Template, Ref, GetAtt, Select, Cidr
import troposphere.ec2 as ec2

t = Template()
r_vpc = t.add_resource(ec2.VPC(
  'VPC',
  CidrBlock='10.0.0.0/24'
))

r_subnet_az1 = t.add_resource(ec2.Subnet(
  'SubnetAz1',
  CidrBlock=Select(0, Cidr(GetAtt(r_vpc, 'CidrBlock'), 2, 7)),
  VpcId=Ref(r_vpc),
  AvailabilityZone='eu-west-1a'
))

print(t.to_yaml())
