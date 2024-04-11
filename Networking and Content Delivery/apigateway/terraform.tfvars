# Global

region = "ap-south-1"
domain_name = "a2suite.co.uk"  # Use the domain name that you want to use 
acm_certificate = "arn:aws:acm:ap-south-1:023408401842:certificate/6d6faae5-008a-407d-9136-7c22379c37f9" # Use your certificate ARN that you want to use for SSL Termination
app_name = "sampleapp"

# Api Gateway

resource_mapping_uri = "arn:aws:apigateway:ap-south-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-south-1:023408401842:function:practiceapp-lambda-function/invocations"