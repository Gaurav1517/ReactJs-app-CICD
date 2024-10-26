pipeline{
    agent any
    tools {
        nodejs 'nodejs'
    }

    stages{
        stage('SCM Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/Gaurav1517/ReactJs-app-CICD.git'
            }
        }
        stage('NPM Install'){
            steps{
                sh "pwd"
                sh "npm install"
            }
        }
        stage('Node Build'){
            steps{
                sh "npm run build"
            }
        }
        stage('Install Dependencies') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-jenkins-user', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'chmod +x script.sh || true'
                    sh './script.sh'
                }
            }
        }
        stage('Create S3 bucket playbook') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-jenkins-user', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh "ansible-playbook create-s3.yml -vvv"
                }
            }
        }
    }
}