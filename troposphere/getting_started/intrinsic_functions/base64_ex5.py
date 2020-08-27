from troposphere import Template, Parameter, Sub, Ref, Base64
import troposphere.ec2 as ec2

t = Template()

p_environment = t.add_parameter(Parameter('Environment', Type='String'))

with open("userdata.sh", "r") as f:
  t_userdata = f.read()

t.add_resource(ec2.Instance(
  'Ec2Instance',
  ImageId='ami-16fd7026',
  InstanceType='t3.nano',
  KeyName='mykey',
  UserData=Base64(Sub(
    t_userdata,
    MyVar=Ref(p_environment)
  ))
))

print(t.to_yaml(clean_up=True))
