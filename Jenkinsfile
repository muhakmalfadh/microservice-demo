pipeline {
    agent any

    stages {
        stage('Build, Tag, and Push Docker Images') {
            parallel {
                stage('Build and Push vote-worker') {
                    steps {
                        script {
                          withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                              sh "docker build -t muhakmalfadh/microservice-demo-vote-worker:latest vote-worker"
                              sh "docker push muhakmalfadh/microservice-demo-vote-worker:latest"
                          }
                        }
                    }
                }
                stage('Build and Push results-app') {
                    steps {
                        script {
                          withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                              sh "docker build -t muhakmalfadh/microservice-demo-results-app:latest results-app"
                              sh "docker push muhakmalfadh/microservice-demo-results-app:latest"
                          }
                        }
                    }
                }
                stage('Build and Push web-vote-app') {
                    steps {
                        script {
                          withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                              sh "docker build -t muhakmalfadh/microservice-demo-web-vote-app:latest web-vote-app"
                              sh "docker push muhakmalfadh/microservice-demo-web-vote-app:latest"
                          }
                        }
                    }
                }
            }
        }
    }
}
