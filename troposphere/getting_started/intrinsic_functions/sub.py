from troposphere import Template, Parameter, Tags, Ref, Sub
import troposphere.ec2 as ec2

t = Template()

p_application = t.add_parameter(Parameter('Application', Type='String'))

r_vpc = t.add_resource(ec2.VPC(
  'VPC',
  CidrBlock='10.0.0.0/24',
  Tags=Tags(Name=Sub(f'${{{p_application.title}}}-vpc'))
))

r_subnet_az1 = t.add_resource(ec2.Subnet(
  'SubnetAz1',
  CidrBlock='10.0.0.0/25',
  VpcId=Ref(r_vpc),
  AvailabilityZone='eu-west-1a',
  Tags=Tags(Name=Sub('${var}-vpc', {
    'var': Ref(p_application)
  }))
))

print(t.to_yaml())
