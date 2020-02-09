const cdk = require('@aws-cdk/core')
const ec2 = require("@aws-cdk/aws-ec2")

class SimpleStack extends cdk.Stack  {
    constructor(scope, id, props) {
      super(scope, id, props)
      new ec2.Vpc(this, 'VPC')
  }
}

const app = new cdk.App()
new SimpleStack(app, 'SimpleStack')