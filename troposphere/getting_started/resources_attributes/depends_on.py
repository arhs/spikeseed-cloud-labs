from troposphere import Template, Ref
import troposphere.ec2 as ec2

t = Template()

r_vpc = t.add_resource(ec2.VPC(
  'VPC',
  CidrBlock='10.0.0.0/16'
))

r_internet_gateway = t.add_resource(ec2.InternetGateway('InternetGateway'))

r_gateway_attachment = t.add_resource(ec2.VPCGatewayAttachment(
  'VPCGatewayAttachment',
  VpcId=Ref(r_vpc),
  InternetGatewayId=Ref(r_internet_gateway)
))

r_public_route_table = t.add_resource(ec2.RouteTable(
  'PublicRouteTable',
  VpcId=Ref(r_vpc)
))

r_route_igw = t.add_resource(ec2.Route(
  'RouteInternetGateway',
  DependsOn=r_gateway_attachment,
  GatewayId=Ref(r_internet_gateway),
  DestinationCidrBlock='0.0.0.0/0',
  RouteTableId=Ref(r_public_route_table),
))

print(t.to_yaml())
