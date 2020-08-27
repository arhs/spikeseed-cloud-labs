from troposphere import Template, Parameter, Ref, Select, Split
import troposphere.ec2 as ec2

t = Template()

p_vpc_cidr = t.add_parameter(Parameter('VpcCidr', Type='String', Default='10.0.0.0/24'))
p_subnets_cidr = t.add_parameter(Parameter('Subnets', Type='String', Default='10.0.0.0/25,10.0.0.128/25'))

r_vpc = t.add_resource(ec2.VPC(
    'VPC',
    CidrBlock=Ref(p_vpc_cidr)
))

t.add_resource(
  [
    ec2.Subnet(
      'SubnetAz1',
      CidrBlock=Select(0, Split(',', Ref(p_subnets_cidr))),
      VpcId=Ref(r_vpc),
      AvailabilityZone='eu-west-1a'
    ),
    ec2.Subnet(
      'SubnetAz2',
      CidrBlock=Select(1, Split(',', Ref(p_subnets_cidr))),
      VpcId=Ref(r_vpc),
      AvailabilityZone='eu-west-1b'
    )
  ]
)

print(t.to_yaml())
