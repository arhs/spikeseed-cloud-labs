from troposphere import Template, Output, GetAtt
import troposphere.s3 as s3

t = Template()

s3bucket = t.add_resource(s3.Bucket(
  'S3Bucket',
  AccessControl=s3.PublicRead,
  WebsiteConfiguration=s3.WebsiteConfiguration(
    IndexDocument='index.html',
    ErrorDocument='error.html'
  )
))

t.add_output(
  Output(
    'WebsiteURL',
    Value=GetAtt(s3bucket, 'WebsiteURL'),
    Description='URL for website hosted on S3'
  )
)

print(t.to_yaml())
