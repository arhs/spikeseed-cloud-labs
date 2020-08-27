from troposphere import Template, Ref, Output, Join
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
  AvailabilityZone='eu-west-1a'
))

r_subnet_az2 = t.add_resource(ec2.Subnet(
  'SubnetAz2',
  CidrBlock='10.0.0.128/25',
  VpcId=Ref(r_vpc),
  AvailabilityZone='eu-west-1b'
))

t.add_output(Output(
  'SubnetIds',
  Value=Join(',', [
    Ref(r_subnet_az1), Ref(r_subnet_az2)
  ])
))

print(t.to_yaml())
