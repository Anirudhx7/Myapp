pipeline {
 
    agent { label 'remote' }
 
    environment {
        IMAGE_NAME = "my-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }
 
    stages {
 
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
 
        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }
 
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                sh """
                ansible-playbook -i ansible/inventory ansible/deploy.yml \
                -e image=${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
 
    post {
        success {
            echo "Build #${BUILD_NUMBER} deployed successfully 🚀"
        }
        failure {
            echo "Build failed ❌"
        }
    }
}
