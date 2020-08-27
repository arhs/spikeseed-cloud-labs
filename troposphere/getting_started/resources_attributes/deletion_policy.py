from troposphere import Template
import troposphere.s3 as s3

t = Template()

t.add_resource(s3.Bucket(
    'S3Bucket',
    DeletionPolicy='Retain'
))

print(t.to_yaml())
