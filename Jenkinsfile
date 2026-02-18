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
                echo "Checking out source..."
                checkout scm
                sh "git log -1 --oneline"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building image ${IMAGE_NAME}:${IMAGE_TAG}"
                sh """
                docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} .
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Deploy Container') {
            steps {
                echo "Deploying container..."

                sh """
                docker rm -f myapp || true
                docker run -d \
                  --name myapp \
                  -p 80:80 \
                  ${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker image prune -f"
            }
        }
    }

    post {
        success {
            echo "Build ${BUILD_NUMBER} deployed successfully 🚀"
            sh "docker ps"
        }
        failure {
            echo "Build failed ❌"
        }
    }
}
