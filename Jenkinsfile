pipeline {
    agent none

    environment {
        DOCKER_CREDENTIALS = 'dockerhub-credential'
        JAVA_IMAGE_NAME = 'phuong06061994/java-demo'
        NODE_IMAGE_NAME = 'phuong06061994/angular-demo'
        GIT_CREDENTIALS = 'github-credential'
        JAVA_GIT_REPO_URL = 'https://github.com/Phuong06061994/java-demo.git'
        NODE_GIT_REPO_URL = 'https://github.com/Phuong06061994/angular-demo.git'
        REMOTE_HOST = 'ec2-user@ec2-54-174-102-199.compute-1.amazonaws.com'
        SSH_CREDENTIALS = 'ec2-credential'
        REMOTE_COMPOSE_PATH = '/home/ec2-user/build-app'
        JAVA_IMAGE_TAG = ''
        NODE_IMAGE_TAG = ''
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
                                    JAVA_IMAGE_TAG = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
                                    echo "Java Image Tag: ${JAVA_IMAGE_TAG}"
                                }
                            }
                        }
                        stage('Build Java Docker Image') {
                            steps {
                                script {
                                    sh """
                                        docker build -t ${JAVA_IMAGE_NAME}:${JAVA_IMAGE_TAG} -f my-app/Dockerfile my-app
                                    """
                                }
                            }
                        }
                        stage('Push Java Docker Image') {
                            steps {
                                script {
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
                                    NODE_IMAGE_TAG = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
                                    echo "Node Image Tag: ${NODE_IMAGE_TAG}"
                                }
                            }
                        }
                        stage('Build Node Docker Image') {
                            steps {
                                script {
                                    sh """
                                        docker build -t ${NODE_IMAGE_NAME}:${NODE_IMAGE_TAG} -f my-app/Dockerfile my-app
                                    """
                                }
                            }
                        }
                        stage('Push Node Docker Image') {
                            steps {
                                script {
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
        }

        stage('Update docker-compose.yml with Image Tags') {
            agent { label 'java-slave' }
            steps {
                checkout scm
                script {
                    // Debugging: Print the tags to make sure they are correctly set
                    echo "Java Image: ${JAVA_IMAGE_NAME}:${JAVA_IMAGE_TAG}"
                    echo "Node Image: ${NODE_IMAGE_NAME}:${NODE_IMAGE_TAG}"

                    // Update docker-compose.yml with the correct image tags
                    sh """
                        sed -i 's|image: phuong06061994/java-demo:.*|image: ${JAVA_IMAGE_NAME}:${JAVA_IMAGE_TAG}|' docker-compose.yml
                        sed -i 's|image: phuong06061994/angular-demo:.*|image: ${NODE_IMAGE_NAME}:${NODE_IMAGE_TAG}|' docker-compose.yml
                        # Print the contents of docker-compose.yml after sed
                        cat docker-compose.yml
                    """
                }
            }
        }

        stage('Prepare Remote Directory and Copy docker-compose.yml') {
            agent { label 'java-slave' }
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        // Debugging: Print the contents of docker-compose.yml before copying
                        sh """
                            echo "Contents of docker-compose.yml before copying:"
                            cat docker-compose.yml
                        """
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} 'mkdir -p ${REMOTE_COMPOSE_PATH}'
                            scp -o StrictHostKeyChecking=no docker-compose.yml ${REMOTE_HOST}:${REMOTE_COMPOSE_PATH}/docker-compose.yml
                            scp -r -o StrictHostKeyChecking=no nginx.conf/ ${REMOTE_HOST}:${REMOTE_COMPOSE_PATH}/nginx.conf/
                        """
                    }
                }
            }
        }

        stage('Deploy on Remote Host') {
            agent { label 'java-slave' }
            steps {
                script {
                    sshagent([SSH_CREDENTIALS]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} \'
                                cd ${REMOTE_COMPOSE_PATH}
                                docker stop \$(docker ps -q)
                                docker rm \$(docker ps -a -q)
                                docker-compose up -d
                            \'
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            node('java-slave') {
                sh "docker system prune -af"
            }
        }
    }
}
