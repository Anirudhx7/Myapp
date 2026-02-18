pipeline {

    agent { label 'remote' }

    environment {
        IMAGE_NAME = "my-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    options {
        timestamps()
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
                sh "git log -1 --oneline"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image version ${IMAGE_TAG}..."

                sh """
                docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Remove Old Container') {
            steps {
                echo "Removing old container if exists..."
                sh "docker rm -f myapp || true"
            }
        }

        stage('Deploy New Container') {
            when {
                branch 'main'
            }
            steps {
                echo "Starting new container..."

                sh """
                docker run -d \
                  --name myapp \
                  -p 80:80 \
                  ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Cleanup Old Images') {
            steps {
                echo "Cleaning unused images..."
                sh "docker image prune -f"
            }
        }
    }

    post {
        success {
            echo "Build #${BUILD_NUMBER} deployed successfully 🚀"
            sh "docker ps"
        }
        failure {
            echo "Build failed ❌"
        }
    }
}
