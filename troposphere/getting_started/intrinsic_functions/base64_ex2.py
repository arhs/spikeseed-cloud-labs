from troposphere import Template
from troposphere.helpers import userdata
import troposphere.ec2 as ec2

t = Template()
t.add_resource(ec2.Instance(
  'Ec2Instance',
  ImageId='ami-16fd7026',
  InstanceType='t3.nano',
  KeyName='mykey',
  UserData=userdata.from_file('userdata.sh'),
))

print(t.to_yaml())
