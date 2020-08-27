from troposphere import Template, Parameter, Tags, Sub
import troposphere.ec2 as ec2

t = Template()

p_account_code = t.add_parameter(Parameter('AccountCode', Type='String'))
p_region_code = t.add_parameter(Parameter('RegionCode', Type='String'))
p_application = t.add_parameter(Parameter('Application', Type='String'))

r_vpc = t.add_resource(ec2.VPC(
  'VPC',
  CidrBlock='10.0.0.0/16',
  Tags=Tags(
    Application='demo-app',
    Name=Sub('${AccountCode}-${RegionCode}-${Application}-vpc')
  )
))

print(t.to_yaml())
