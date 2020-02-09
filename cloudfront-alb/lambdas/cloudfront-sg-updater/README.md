# Initializing the security Groups

https://aws.amazon.com/blogs/security/how-to-automatically-update-your-security-groups-for-amazon-cloudfront-and-aws-waf-by-using-aws-lambda/

1. Go to the AWS Console -> Services -> Lambda
2. Create a test event (InitializationEvent) with the content below

        {
          "Records": [
            {
              "EventVersion": "1.0",
              "EventSubscriptionArn": "arn:aws:sns:EXAMPLE",
              "EventSource": "aws:sns",
              "Sns": {
                "SignatureVersion": "1",
                "Timestamp": "1970-01-01T00:00:00.000Z",
                "Signature": "EXAMPLE",
                "SigningCertUrl": "EXAMPLE",
                "MessageId": "95df01b4-ee98-5cb9-9903-4c221d41eb5e",
                "Message": "{\"create-time\": \"yyyy-mm-ddThh:mm:ss+00:00\", \"synctoken\": \"0123456789\", \"md5\": \"7fd59f5c7f5cf643036cbd4443ad3e4b\", \"url\": \"https://ip-ranges.amazonaws.com/ip-ranges.json\"}",
                "Type": "Notification",
                "UnsubscribeUrl": "EXAMPLE",
                "TopicArn": "arn:aws:sns:EXAMPLE",
                "Subject": "TestInvoke"
              }
            }
          ]
        }

3. Click `Test`
4. You will get an error message like:

        "MD5 Mismatch: got 752b804e2825dffc79bce7c10acaf201 expected 7fd59f5c7f5cf643036cbd4443ad3e4b"

5. In the event created previously, change the expected value "7fd59f5c7f5cf643036cbd4443ad3e4b" by the "got" value (752b804e2825dffc79bce7c10acaf201 in this example).
6. Check all 4 security groups