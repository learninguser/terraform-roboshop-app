# Terraform Module for Roboshop LB, Auto scaling components

## Mandatory variables

- tags: Tags for the resource
- vpc_id: VPC information i.e. in which VPC should the resources be provisioned
- subnet_ids: Subnet IDs for the resources to be provisioned in
- component_sg_id: Security Group ID that should be attached to the reource
- iam_instance_profile: IAM role to be attached to the instance to access AWS resources
- centos_ami_id: AMI ID of the CentOS image
- centos_password: Password for the CentOS image
- app_alb_listener_arn: ARN of the APP ALB listener rule
- rule_priority: Integer value to prioritize the route

## Optional variables

- project_name: Name of the project. Default value is "roboshop"
- environment: Project Environment. Default is "dev"
- zone_name: Domain name. Default is "learninguser.shop"  
