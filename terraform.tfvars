region               = "us-east-1"
vpc_cidr_block       = "10.10.0.0/16"
vpc_name             = "utc-app"
environment          = "dev"
team                 = "config management"
my-ip-address        = "71.249.114.161/32" ## Replace this by your own ip address. Run the command "curl ifconfig.me" to get your personal ip adress and replace it in this variable followed by /32 . It should be < "your_own_ip/32" >
key_pair             = "utc-key"
private_key_filename = "utc-key.pem"
certificate_arn      = "arn:aws:acm:us-east-1:672451395673:certificate/566f5482-067e-4c61-a9c1-3227469cbcdf" ###Please replace the value of the certificate arn by your own certificate arn
zone_id              = "Z005070239P6G69V0VO74" ###Replace this by the ID of your hosted zone in Route 53
route53_record_name  = "class.detra-llc.com"  ###Replace this by the subdomain you want to be created. Please make sure that the domain is already hosted in a zone in Route53
