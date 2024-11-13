pipeline {
    agent none

    environment {
        DOCKER_CREDENTIALS = 'dockerhub-credential'
        JAVA_IMAGE_NAME = 'phuong06061994/java-demo'
        NODE_IMAGE_NAME = 'phuong06061994/angular-demo'
        GIT_CREDENTIALS = 'github-credential'
        JAVA_GIT_REPO_URL = 'https://github.com/Phuong06061994/java-demo.git'
        NODE_GIT_REPO_URL = 'https://github.com/Phuong06061994/angular-demo.git'
        REMOTE_HOST = 'ec2-user@ec2-44-206-232-108.compute-1.amazonaws.com'
        SSH_CREDENTIALS = 'ec2-credential'
        REMOTE_COMPOSE_PATH = '/home/ec2-user/build-app'
    }

    stages {
        stage('Parallel Build and Push') {
            parallel {
                stage('Build and Push Java App') {
                    agent { label 'java-slave' }
                    stages {
                        stage('Checkout Java Code') {
                            steps {
                                git url: JAVA_GIT_REPO_URL, credentialsId: GIT_CREDENTIALS, branch: 'main'
                            }
                        }
                        stage('Set Java Image Tag') {
                            steps {
                                script {
                                    env.JAVA_IMAGE_TAG = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
                                    echo "Java Image Tag: ${JAVA_IMAGE_TAG}"
                                }
                            }
                        }
                        stage('Build Java Docker Image') {
                            steps {
                                sh "docker build -t ${JAVA_IMAGE_NAME}:${JAVA_IMAGE_TAG} -f my-app/Dockerfile my-app"
                            }
                        }
                        stage('Push Java Docker Image') {
                            steps {
                                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                    sh """
                                        echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                                        docker push ${JAVA_IMAGE_NAME}:${JAVA_IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }

                stage('Build and Push Node App') {
                    agent { label 'node-slave' }
                    stages {
                        stage('Checkout Node Code') {
                            steps {
                                git url: NODE_GIT_REPO_URL, credentialsId: GIT_CREDENTIALS, branch: 'main'
                            }
                        }
                        stage('Set Node Image Tag') {
                            steps {
                                script {
                                    env.NODE_IMAGE_TAG = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
                                    echo "Node Image Tag: ${NODE_IMAGE_TAG}"
                                }
                            }
                        }
                        stage('Build Node Docker Image') {
                            steps {
                                sh "docker build -t ${NODE_IMAGE_NAME}:${NODE_IMAGE_TAG} -f my-app/Dockerfile my-app"
                            }
                        }
                        stage('Push Node Docker Image') {
                            steps {
                                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                    sh """
                                        echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                                        docker push ${NODE_IMAGE_NAME}:${NODE_IMAGE_TAG}
                                    """
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Update docker-compose.yml with Image Tags') {
            agent { label 'java-slave' }
            steps {
                script {
                    // Update image tags in docker-compose.yml
                    sh """
                        sed -i 's|image: phuong06061994/java-demo:.*|image: ${JAVA_IMAGE_NAME}:${JAVA_IMAGE_TAG}|' docker-compose.yml
                        sed -i 's|image: phuong06061994/angular-demo:.*|image: ${NODE_IMAGE_NAME}:${NODE_IMAGE_TAG}|' docker-compose.yml
                    """

                    // Capture the updated file content
                    def composeFileContent = readFile 'docker-compose.yml'
                    echo "Updated docker-compose.yml:\n${composeFileContent}"

                    // Store it for later use
                    env.COMPOSE_FILE_CONTENT = composeFileContent
                }
            }
        }

        stage('Transfer docker-compose.yml to Remote Host') {
            agent { label 'java-slave' }
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    script {
                        // Recreate docker-compose.yml on the remote host using the captured content
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} 'mkdir -p ${REMOTE_COMPOSE_PATH}'
                            echo "\$COMPOSE_FILE_CONTENT" > docker-compose.yml
                            scp -o StrictHostKeyChecking=no docker-compose.yml ${REMOTE_HOST}:${REMOTE_COMPOSE_PATH}/docker-compose.yml
                        """
                    }
                }
            }
        }

        stage('Deploy on Remote Host') {
            agent { label 'java-slave' }
            steps {
                sshagent([SSH_CREDENTIALS]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} '
                            cd ${REMOTE_COMPOSE_PATH}
                            docker-compose down
                            docker-compose up -d
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            agent { label 'java-slave' }
            steps {
                sh "docker system prune -af"
            }
        }
    }
}
