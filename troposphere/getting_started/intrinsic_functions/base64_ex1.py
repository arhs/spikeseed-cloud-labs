from troposphere import Template, Join, Base64
import troposphere.ec2 as ec2

t = Template()
t.add_resource(ec2.Instance(
  'Ec2Instance',
  ImageId='ami-16fd7026',
  InstanceType='t3.nano',
  KeyName='mykey',
  UserData=Base64(Join('', [
    '#!/bin/bash\n',
    'echo "Hello"\n'
  ])),
))

print(t.to_yaml())
