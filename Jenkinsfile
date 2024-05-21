pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
              sh "kubectl cluster-info"
            }
        }
    }
}
