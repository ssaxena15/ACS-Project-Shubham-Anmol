1. Create S3 Images storage and add the following to bucket policy:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::<bucket-name>/<folder>/*"
        }
    ]
}
    ** Upload some images having number 0-9 as filename and extension name "jpg" 

2. Copy the ssh key file to webapp_dev/modules/aws_ec2/ (Key is already present in all 3 environment)
3. in tf_aws directory >>

Run: terraform init
Run: terraform apply

4. change directory to 'webapp_dev' or 'webapp_prod' or 'webapp_staging' (to deploy environment)
 Run: terraform init
 Run: terraform plan
 Run: terraform apply
5. Open the load balancer DNS name to view website

6. To view traffic behind load balancer
  
Go to aws_ec2 directory || sudo chmod 400 shubhamkey.pem|| Copy key to Bastion Public IP > scp -i shubhamkey.pem shubhamkey.pem ec2-user@public ip of bastion:
|| ssh to bastion > ssh -i shubhamkey.pem ec2-user@50.16.98.253 (Public IP of Bastion)
From bastion SSH to load balancer instance unamed.
sudo su
cd /var/log/httpd/
tail -f access_log

7. To view autoscaling, Go to Load balancer and then auto scaling group.
