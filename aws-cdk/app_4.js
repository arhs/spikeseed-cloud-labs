const cdk = require('@aws-cdk/core')
const ec2 = require("@aws-cdk/aws-ec2")
const elbv2 = require('@aws-cdk/aws-elasticloadbalancingv2')

class VpcStack extends cdk.Stack  {
    constructor(scope, id, props) {
      super(scope, id, props)
      this.vpc = new ec2.Vpc(this, 'VPC', {
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

class AlbStack extends cdk.Stack {
  constructor(scope, id, vpcStack, props) {
      super(scope, id, props)

      new elbv2.ApplicationLoadBalancer(this, 'LB', {
          vpc: vpcStack.vpc,
          internetFacing: true
      })
  }
}


const app = new cdk.App()
const vpcStack = new VpcStack(app, 'VpcStack')
new AlbStack(app, 'AlbStack', vpcStack)
