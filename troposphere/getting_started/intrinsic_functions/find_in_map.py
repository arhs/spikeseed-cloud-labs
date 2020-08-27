from troposphere import Template, Parameter, Ref, FindInMap
import troposphere.ec2 as ec2

t = Template()
p_environment = t.add_parameter(Parameter('Environment', Type='String'))

t.add_mapping('EnvironmentMap', {
    'production': {'InstanceType': 't3.micro'},
    'development': {'InstanceType': 'm4.xlarge'}
})

t.add_resource(ec2.Instance(
    'Ec2Instance',
    ImageId='ami-7f418316',
    InstanceType=FindInMap('EnvironmentMap', Ref(p_environment), 'InstanceType')
))

print(t.to_yaml())
