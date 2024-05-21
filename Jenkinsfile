pipeline {
  agent any

  stages {
    

    stage('Build, Tag, and Push Docker Images') {
      withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: '', namespace: 'devops-tools', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.2.82:6443') {
        sh 'kubectl get pods -n devops-tools'
      }

      parallel {
        stage('Build & Push vote-worker') {
          steps {
            script {
              withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker build -t muhakmalfadh/microservice-demo-vote-worker:latest vote-worker"
                sh "docker push muhakmalfadh/microservice-demo-vote-worker:latest"
              }
            }
          }
        }

        stage('Build & Push results-app') {
          steps {
            script {
              withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                sh "docker build -t muhakmalfadh/microservice-demo-results-app:latest results-app"
                sh "docker push muhakmalfadh/microservice-demo-results-app:latest"
              }
            }
          }
        }

        stage('Build & Push web-vote-app') {
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