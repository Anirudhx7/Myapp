pipeline {
 
    agent { label 'remote' }
 
    environment {
        IMAGE_NAME = "my-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        DOCKERHUB_REPO = "yourdockerhubusername/my-app"
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
 
        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    """
                }
            }
        }
 
        stage('Push Image to DockerHub') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}:${IMAGE_TAG}
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
                docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                docker push ${DOCKERHUB_REPO}:latest
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
                -e image=${DOCKERHUB_REPO}:${IMAGE_TAG}
                """
            }
        }
    }
 
    post {
        success {
            echo "Deployment successful 🚀"
        }
        failure {
            echo "Build failed ❌"
        }
    }
}
