pipeline {
    agent {lable 'java-slave-082dc27b'}

    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying to production...'
            }
        }
    }
}
