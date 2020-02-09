const cdk = require('@aws-cdk/core')
const ec2 = require("@aws-cdk/aws-ec2")

class SimpleStack extends cdk.Stack  {
    constructor(scope, id, props) {
      super(scope, id, props)
      new ec2.Vpc(this, 'VPC', {
        cidr: '10.128.0.0/16',
        natGateways: 1,
        maxAZs: 2,
        subnetConfiguration: [
            {
              cidrMask: 24,
              name: 'Web',
              subnetType: ec2.SubnetType.PUBLIC
            },
            {
              cidrMask: 24,
              name: 'Application',
              subnetType: ec2.SubnetType.PRIVATE
            },
            {
              cidrMask: 24,
              name: 'Database',
              subnetType: ec2.SubnetType.ISOLATED
            }
        ]
    })
  }
}

const app = new cdk.App()
new SimpleStack(app, 'SimpleStack')