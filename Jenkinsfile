pipeline {
    agent { label 'java-slave-082dc27b' }

    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
                sh './mvnw clean install'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh './mvnw test'
            }
        }

        stage('Deploy') {
            steps {
                echo ' to production...'
                sh './deploy.sh'
            }
        }
    }

    post {
        success {
            slackSend(channel: '#builds', message: "Build succeeded!")
        }
        failure {
            slackSend(channel: '#builds', message: "Build failed!")
        }
    }
}
