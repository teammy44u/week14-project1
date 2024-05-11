ATTENTION!!!!!!
THE FOLLOWING CHANGES NEED TO BE MADE BEFORE USING THIS TERRAFORM CONFIG FILES. PLEASE UPDATE THE terraform.tfvars AND THE version.tf TO SPECIFY YOUR OWN RECORDS.

- In the terraform.tfvars: Please replace the value of "my-ip-address" on line 6 by your own ip-address. You can run the command "curl ifconfig.me" to get your personal ip adress

- In the terraform.tfvars: Please replace the value of the certificate arn in line 9 by your own certificate arn. You can get this info by navigating to your AWS ACM and then copy the ARN of your certificate.

- In the terraform.tfvars: Please replace the value of the Zone ID in line 10 by the ID of your hosted zone in Route 53. You can get this info by navigating to the hosted zone page on AWS. 

- In the terraform.tfvars: Please specify the route53 record name on line 11 this by the subdomain you want to be created. Please make sure that the domain you use is already hosted in a zone in Route53 

- In the version.tf file, (backend block): please replace the name of the bucket with your own s3 bucket name; 

- In the version.tf file, Replace the name of the DynamoDB Table by your own DynamoDB.