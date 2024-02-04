variable "common_tags" {
  default = {
    Project     = "roboshop"
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "tags" {
}

variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "zone_name" {
  default = "learninguser.shop"
}

variable "vpc_id" {
  
}

variable "subnet_ids" {

}

variable "component_sg_id" {
  
}

variable "iam_instance_profile" {
  
}

variable "centos_ami_id" {
  
}

variable "centos_password" {
  
}

variable "app_alb_listener_arn" {
  
}

variable "rule_priority" {
  
}