pipeline {
 
    agent { label 'remote' }
 
    environment {
        IMAGE_NAME = "my-app"
    }
 
    stages {
 
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
 
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }
 
        stage('Run Tests') {
            steps {
                sh "chmod +x test/test.sh"
                sh "./test/test.sh"
            }
        }
 
        stage('Deploy to Production') {
            steps {
                input message: 'Approve Production Deployment?'
 
                sh """
                ansible-playbook -i ansible/inventory.ini ansible/deploy.yml
                """
            }
        }
    }
 
    post {
        failure {
            echo "Build failed!"
        }
        success {
            echo "Deployment completed!"
        }
    }
}
