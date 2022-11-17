/*
  ON PREM VPC Configuration
*/
variable "onprem_vpc_id" {
  description = "OnPrem VPC id."
  default = ""
}

variable "onprem_bindserver_allow_ssh" {
  description = "Allow ssh to onprem bindserver"
  default = ""
}

variable "ubuntu_bindserver_ami_id" {
  description = "Ubuntu Bind Server AMI ID"
  default = "ami-08c40ec9ead489470"
}

variable "ubuntu_bindserver_instance_type" {
  description = "Ubuntu Bind Server instance type"
  default = "t2.micro"
}

variable "bindserver_subnet_id" {
  description = "BindServer Subnet Id"
  default = ""
}


variable "onprem_test_domain_name" {
  description = "OnPrem DNS test domain name"
  default = "allcloudonprem.com"
}

variable "onprem_domain_dummyresource_name" {
  description = "Onprem Domain dummy resource name"
  default = "dnstest"
}

variable "onprem_domain_dummyresource_ipaddress" {
  description = "This can be any random ip address. We just map above dummy resource name to this ip address to test DNS resolution."
  default = "192.168.2.9"
}


/* 
  AWS VPC Configuration
*/

variable "awsvpc_id" {
  description = "AWS VPC id."
  default = ""
}

variable "aws_private_hostedzone" {
  description = "AWS private hosted zone"
  default = "allcloudawsvpc.com"
}

# Route 53 resolver configuration.
variable "aws_resolver_endpoints_subnet_id1" {
  description = "Subnet Ids used by Route53 Resolver Inbound and Outbound endpoints.Technically can be public or private subnet id. But PoC had been tested on Public Subnet(Easy to log into DNS test ec2 instance without Bastion Host).For security best practice use 'Private' subnet."
  default = ""
}

variable "aws_resolver_endpoints_subnet_id2" {
  description = "Subnet Ids used by Route53 Resolver Inbound and Outbound endpoints.Technically can be public or private subnet id. But PoC had been tested on Public Subnet(Easy to log into DNS test ec2 instance without Bastion Host).For security best practice use 'Private' subnet."
  default = ""
}
# In
variable "aws_route53_inbound_endpoint_ip1" {
  description = "AWS Route53 Inbound Endpoint IP1. We need to explicitly provide these ip because we need define forwarder ips in Bind9 server configuration. Generally select last - 1 IP address of subnet."
  default = "192.168.1.62"
}

variable "aws_route53_inbound_endpoint_ip2" {
  description = "AWS Route53 Inbound Endpoint IP2. We need to explicitly provide these ip because we need define forwarder ips in Bind9 server configuration. Generally select last - 1 IP address of subnet."
  default = "192.168.1.126"
}

variable "aws_private_hostedzone_dummyresource_name" {
  description = "AWS VPC private Domain dummy resource name"
  default = "dnstest"
}

variable "aws_private_hostedzone_dummyresource_ipaddress" {
  description = "This can be any random ip address. We just map above dummy resource name to this ip address to test DNS resolution."
  default = "192.168.1.254"
}
/* 
  Common Configuration
*/

variable "ssh_keyname" {
  description = "SSH key name"
  default = ""
}
