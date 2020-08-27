from troposphere import Template, Sub, Base64
import troposphere.ec2 as ec2

t = Template()

userdata = """#!/bin/bash
echo "Hello"
"""

t.add_resource(ec2.Instance(
  'Ec2Instance',
  ImageId='ami-16fd7026',
  InstanceType='t.nano',
  KeyName='mykey',
  UserData=Base64(Sub(userdata))
))

print(t.to_yaml(clean_up=True))
