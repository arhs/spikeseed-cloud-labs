from troposphere import Template, ImportValue
import troposphere.ec2 as ec2
t = Template()

t.add_resource(
  ec2.Instance(
    'Ec2Instance',
    ImageId='ami-12345678',
    InstanceType='t3.nano',
    KeyName='mykey',
    SubnetId=ImportValue('demo-subnet-az1')
  )
)

print(t.to_yaml())
