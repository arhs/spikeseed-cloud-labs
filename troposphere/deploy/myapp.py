from troposphere import Template, Parameter, Tags, Sub
import troposphere.ec2 as ec2
from troposphere.constants import STRING

import cfn

t = Template()
t.set_version()

p_account_code = t.add_parameter(Parameter('AccountCode', Type=STRING))
p_region_code = t.add_parameter(Parameter('RegionCode', Type=STRING))
p_application = t.add_parameter(Parameter('Application', Type=STRING))

t.add_resource(ec2.VPC(
  'VPC',
  CidrBlock='10.0.0.0/16',
  Tags=Tags(
    Application='demo-app',
    Name=Sub('${AccountCode}-${RegionCode}-${Application}-vpc')
  )
))

if __name__ == "__main__":
  cfn.generate(t, '.cfn/sample.yml', cfn.TemplateFormat.YAML)

  cfn.deploy('l-ue2-mydemostack', '.cfn/sample.yml',
             template_parameters={
               'AccountCode': 'l',
               'RegionCode': 'ue2',
               'Application': 'demo'
             },
             tags={
               'Name': 'l-ue2-mydemostack',
               'Application': 'demo'
             },
             profile='spikeseed-labs', region='us-east-2'
            )

  # cfn.undeploy('l-ue2-mydemostack', profile='spikeseed-labs', region='us-east-2')
