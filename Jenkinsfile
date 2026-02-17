pipeline {
 
    agent { label 'remote' }   // must match your agent label
 
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
                sh "docker build -t ${IMAGE_NAME}:${env.BRANCH_NAME} ."
            }
        }
 
        stage('Run Tests') {
            steps {
                sh "echo Running tests..."
                sh "chmod +x tests/test.sh"
                sh "./tests/test.sh"
            }
        }
 
        stage('Deploy to Dev') {
            when {
                branch 'dev'
            }
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${env.BRANCH_NAME} ${IMAGE_NAME}:latest
                ansible-playbook -i ansible/inventory ansible/deploy.yml --limit dev
                """
            }
        }
 
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve Production Deployment?'
 
                sh """
                docker tag ${IMAGE_NAME}:${env.BRANCH_NAME} ${IMAGE_NAME}:latest
                ansible-playbook -i ansible/inventory ansible/deploy.yml --limit prod
                """
            }
        }
    }
 
    post {
        failure {
            echo "Build failed!"
        }
        success {
            echo "Pipeline completed successfully!"
        }
    }
}
