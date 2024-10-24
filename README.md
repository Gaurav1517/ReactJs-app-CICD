# React + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh


Steps 1. SCM Git Checkout from this public url 
https://github.com/Gaurav1517/ReactJs-app-CICD.git

Step 2. Install Nodejs plugins on jenkins dashboard .
Nodejs 
Restart the jenkins 
Get login once again on jenkins dashboard.
Go to this path Dashboard> Manage Jenkins > Tools > NodeJS installations
Add NodeJS > 
Name: 
Required

Install automatically
?
Install from nodejs.org
Version

NodeJS 23.4.1
For the underlying architecture, if available, force the installation of the 32bit package. Otherwise the build will fail

Force 32bit architecture
Global npm packages to install
Specify list of packages to install globally -- see npm install -g. Note that you can fix the packages version by using the syntax `packageName@version`
Global npm packages refresh hours
Duration, in hours, before 2 npm cache update. Note that 0 will always update npm cache
72
Save

From decleartive pipeline gnerator 
tools {
  nodejs 'nodejs'
}

Create  a IAM role in aws for S3 
IAM role > Roles > Create Role > AWs service > Service Or use case: EC2 > EC2 > 
Next > AmazonS3FullAccess > Next
Role Name: s3-deploy-reactjs-cicd > Create Role


Create IAM user "jenkins-user"
Assign permission S3FullAccess
Also Generate Access-key and Secret key  for this user Region "us-east-1" (virgina)

Install AWs Cli on jenkins server
Install aws cli in centos 
sudo yum remove awscli
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   ls
   unzip awscliv2.zip
   sudo ./aws/install
   ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
   sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
   which aws
   ls -l /usr/local/bin/aws
   aws --version

To configure an AWS CLI profile, the correct syntax is slightly different from what you've provided. The command should be:
aws configure --profile useraName
aws configure --profile jenkins-user
AWS Access Key ID [None]: Access Key
AWS Secret Access Key [None]: Secret Key
Default region name [None]: us-east-1
Default output format [None]:
aws configure list --profile jenkins-user
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile             jenkins-user           manual    --profile
access_key     ****************Y7GB shared-credentials-file
secret_key     ****************RAnb shared-credentials-file
    region                us-east-1      config-file    ~/.aws/config

export AWS_PROFILE=jenkins-user

Here’s an AWS CLI command sequence to create an S3 bucket, enable versioning, configure static website hosting with index.html as the index document, and apply a bucket policy that allows public access:

    Create the S3 bucket:

    bash

aws s3api create-bucket --bucket <your-bucket-name> --region <your-region> --create-bucket-configuration LocationConstraint=<your-region>

aws s3api create-bucket --bucket reactjsdeploystaticwebsite --region us-east-1 --create-bucket-configuration LocationConstraint=us-east-1

aws s3api put-bucket-versioning --bucket reactjsdeploystaticwebsite --versioning-configuration Status=Enabled

Enable static website hosting:
aws s3 website s3://reactjsdeploystaticwebsite --index-document index.html

Enable versioning:

bash

aws s3api put-bucket-versioning --bucket <your-bucket-name> --versioning-configuration Status=Enabled


Enable static website hosting:

bash

aws s3 website s3://<your-bucket-name>/ --index-document index.html

Set bucket policy to allow public read access:

bash```

    aws s3api put-bucket-policy --bucket <your-bucket-name> --policy '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::<your-bucket-name>/*"
        }
      ]
    }'
```
Replace <your-bucket-name> with your desired bucket name and <your-region> with your region (e.g., us-east-1).


-------------------------------------------
pipeline {
    agent any

    stages {
        stage('Create S3 bucket') {
            steps {
                sh '''
                    aws s3api create-bucket \
                        --bucket reactjsdeploystaticwebsite \
                        --region us-east-1 \
                        --create-bucket-configuration LocationConstraint=us-east-1 \
                        --profile jenkins-user
                '''
            }
        }

        stage('Enable Versioning') {
            steps {
                sh '''
                    aws s3api put-bucket-versioning \
                    --bucket reactjsdeploystaticwebsite \
                    --versioning-configuration Status=Enabled \
                    --profile jenkins-user
                '''
            }
        }

        stage('Enable Static Website Hosting') {
            steps {
                sh '''
                    aws s3 website s3://reactjsdeploystaticwebsite \
                    --index-document index.html \
                    --profile jenkins-user
                '''
            }
        }

        stage('Set Bucket Policy to Allow Public Read Access') {
            steps {
                sh '''
                    aws s3api put-bucket-policy --bucket reactjsdeploystaticwebsite --policy '{
                      "Version": "2012-10-17",
                      "Statement": [
                        {
                          "Effect": "Allow",
                          "Principal": "*",
                          "Action": "s3:GetObject",
                          "Resource": "arn:aws:s3:::reactjsdeploystaticwebsite/*"
                        }
                      ]
                    }' --profile jenkins-user
                '''
            }
        }

        stage('Sync Data to S3 Bucket') {
            steps {
                sh '''
                    echo "Hello from Jenkins" > index.html
                    aws s3 sync . s3://reactjsdeploystaticwebsite --profile jenkins-user
                '''
            }
        }
    }
}


{
  "Id": "Policy1729681416353",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1729681411849",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::reactjsdeploystaticwebsite",
      "Principal": "*"
    }
  ]
}

https://github.com/akannan1087/myAnsibleInfraRepo

https://youtu.be/DsEpu3dIvAg?si=EkdtVPgIQ32rOicx

https://www.coachdevops.com/2023/01/ansible-playbook-for-aws-s3-bucket.html



Install the community.aws collection:

bash

ansible-galaxy collection install community.aws

Make sure you have the necessary dependencies (boto3 and botocore) installed as well:

bash

pip install boto3 botocore

pipeline {
    agent any

    stages {
        stage('Git SCM Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Gaurav1517/ReactJs-app-CICD.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-jenkins-user', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'chmod +x script.js || true'
                    sh './script.js'
                }
            }
        }
        stage('Create S3 bucket playbook') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-jenkins-user', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh "ansible-playbook create-s3.yml"
                }
            }
        }
    }
}

