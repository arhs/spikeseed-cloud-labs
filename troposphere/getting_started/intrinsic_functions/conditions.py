from troposphere import Template, Parameter, Ref, Condition, Equals, And, Or, Not, If
from troposphere import ec2

t = Template()

t.add_parameter(
  [
    Parameter(
      'One',
      Type='String',
    ),
    Parameter(
      'Two',
      Type='String',
    ),
    Parameter(
      'Three',
      Type='String',
    ),
    Parameter(
      'Four',
      Type='String',
    ),
    Parameter(
      'SshKeyName',
      Type='String',
    )
  ]
)

t.add_condition('OneEqualsFoo',
                Equals(
                  Ref('One'),
                  'Foo'
                )
               )

t.add_condition('NotOneEqualsFoo',
                Not(
                  Condition('OneEqualsFoo')
                )
               )

t.add_condition('BarEqualsTwo',
                Equals(
                  'Bar',
                  Ref('Two')
                )
               )

t.add_condition('ThreeEqualsFour',
                Equals(
                  Ref('Three'),
                  Ref('Four')
                )
               )

t.add_condition('OneEqualsFooOrBarEqualsTwo',
                Or(
                  Condition('OneEqualsFoo'),
                  Condition('BarEqualsTwo')
                )
               )

t.add_condition('OneEqualsFooAndNotBarEqualsTwo',
                And(
                  Condition('OneEqualsFoo'),
                  Not(Condition('BarEqualsTwo'))
                )
               )

t.add_condition('OneEqualsFooAndBarEqualsTwoAndThreeEqualsPft',
                And(
                  Condition('OneEqualsFoo'),
                  Condition('BarEqualsTwo'),
                  Equals(Ref('Three'), 'Pft')
                )
               )

t.add_condition('OneIsQuzAndThreeEqualsFour',
                And(
                  Equals(Ref('One'), 'Quz'),
                  Condition('ThreeEqualsFour')
                )
               )

t.add_condition('LaunchInstance',
                And(
                  Condition('OneEqualsFoo'),
                  Condition('NotOneEqualsFoo'),
                  Condition('BarEqualsTwo'),
                  Condition('OneEqualsFooAndNotBarEqualsTwo'),
                  Condition('OneIsQuzAndThreeEqualsFour')
                )
               )

t.add_condition('LaunchWithGusto',
                And(
                  Condition('LaunchInstance'),
                  Equals(Ref('One'), 'Gusto')
                )
               )

t.add_resource(
  ec2.Instance(
    'Ec2Instance',
    Condition='LaunchInstance',
    ImageId=If('ConditionNameEqualsFoo', 'ami-12345678', 'ami-87654321'),
    InstanceType='t1.micro',
    KeyName=Ref('SshKeyName')
  )
)

print(t.to_yaml())
