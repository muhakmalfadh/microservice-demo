pipeline {
    agent any

    stages {
        stage('Build, Tag, and Push Docker Images') {
            parallel {
                stage('Build and Push vote-worker') {
                    steps {
                        script {
                          sh 'git clone https://github.com/muhakmalfadh/microservice-demo.git'
                          sh 'git pull'
                          withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                              sh "sudo docker build -t muhakmalfadh/microservice-demo-vote-worker:latest microservice-demo/vote-worker"
                              sh "sudo docker push muhakmalfadh/microservice-demo-vote-worker:latest"
                          }
                        }
                    }
                }
                stage('Build and Push results-app') {
                    steps {
                        script {
                          sh 'git clone https://github.com/muhakmalfadh/microservice-demo.git'
                          sh 'git pull'
                          withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                              sh "sudo docker build -t muhakmalfadh/microservice-demo-results-app:latest microservice-demo/results-app"
                              sh "sudo docker push muhakmalfadh/microservice-demo-results-app:latest"
                          }
                        }
                    }
                }
                stage('Build and Push web-vote-app') {
                    steps {
                        script {
                          sh 'git clone https://github.com/muhakmalfadh/microservice-demo.git'
                          sh 'git pull'
                          withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                              sh "sudo docker build -t muhakmalfadh/microservice-demo-web-vote-app:latest microservice-demo/web-vote-app"
                              sh "sudo docker push muhakmalfadh/microservice-demo-web-vote-app:latest"
                          }
                        }
                    }
                }
            }
        }
    }
}
