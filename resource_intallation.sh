#!/bin/bash

set -eu

REGION="eu-west-3"
VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_CIDR="10.0.2.0/24"
PUBLIC_AZ="eu-west-3a"
PRIVATE_AZ="eu-west-3b"
KEY_NAME="OriginalKeyPair"        
AMI_ID="ami-03b82db05dca8118d"       


VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --region $REGION \
  --query 'Vpc.VpcId' --output text)

echo "VPC ID: $VPC_ID"


PRIVATE_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $PRIVATE_SUBNET_CIDR \
  --availability-zone $PRIVATE_AZ \
  --query 'Subnet.SubnetId' --output text)

echo "Private Subnet ID: $PRIVATE_SUBNET_ID"


PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $PUBLIC_SUBNET_CIDR \
  --availability-zone $PUBLIC_AZ \
  --query 'Subnet.SubnetId' --output text)

echo "Public Subnet ID: $PUBLIC_SUBNET_ID"


IGW_ID=$(aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=MyInternetGateway}]' \
  --query 'InternetGateway.InternetGatewayId' --output text)

echo "Internet Gateway ID: $IGW_ID"

aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID


ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=MyRouteTable}]' \
  --query 'RouteTable.RouteTableId' --output text)

echo "Route Table ID: $ROUTE_TABLE_ID"

aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID

aws ec2 associate-route-table \
  --subnet-id $PUBLIC_SUBNET_ID \
  --route-table-id $ROUTE_TABLE_ID

SECURITY_GROUP_ID=$(aws ec2 create-security-group \
  --group-name MySecurityGroup \
  --description "My security group" \
  --vpc-id $VPC_ID \
  --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=MySecurityGroup}]' \
  --query 'GroupId' --output text)

echo "Security Group ID: $SECURITY_GROUP_ID"

aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP_ID \
    --subnet-id $PUBLIC_SUBNET_ID \
    --associate-public-ip-address true \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyInstance}]'

echo "EC2 instance launched successfully!"