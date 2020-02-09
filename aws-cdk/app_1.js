const fs = require('fs')
const path = require('path')
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
const cloudAssembly = app.synth()
const files = fs.readdirSync(cloudAssembly.directory)
console.log(files)

for(const file of files) {
  console.log(`File: ${file}`)
  console.log(fs.readFileSync(path.join(cloudAssembly.directory, file), 'utf8'))
}
