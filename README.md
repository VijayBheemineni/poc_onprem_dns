# Issues
When we are destroying infrastructure Terraform is not attaching 'default' DHCP options to VPC. So if you try to do 'terraform destroy' and recreate infrastructure using 'terraform apply', please execute below command.

```sh
aws ec2 associate-dhcp-options --dhcp-options-id <DHCP Options Id> --vpc-id <VPC Id>
```
