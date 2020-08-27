from troposphere import Template, Output

# Pseudo Parameters
from troposphere import (
  AccountId,
  NotificationARNs,
  NoValue,
  Partition,
  Region,
  StackId,
  StackName,
  URLSuffix
)

t = Template()

t.add_output(
  [
    Output(
      'AccountId',
      Value=AccountId
    ),
    Output(
      'NotificationARNs',
      Value=NotificationARNs
    ),
    Output(
      'NoValue',
      Value=NoValue
    ),
    Output(
      'Partition',
      Value=Partition
    ),
    Output(
      'Region',
      Value=Region
    ),
    Output(
      'StackId',
      Value=StackId
    ),
    Output(
      'StackName',
      Value=StackName
    ),
    Output(
      'URLSuffix',
      Value=URLSuffix
    )
  ]
)

print(t.to_yaml())
