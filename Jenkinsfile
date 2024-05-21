pipeline {
    agent {
        kubernetes {
          label 'docker-runner'
        }
    }
    stages {
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh "docker ps"
                }
            }
        }
    }
}
