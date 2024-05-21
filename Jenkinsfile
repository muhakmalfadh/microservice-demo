pipeline {
    agent {
      label 'docker-runner'
    }

    stages {
        stage('List Docker Container') {
            steps {
                sh 'docker ps'
            }
        }
        // stage('Push Docker Image') {
        //     steps {
        //         script {
        //             sh "kubectl exec ${DOCKER_RUNNER_POD} -- docker login -u <username> -p <password>"
        //             sh "kubectl exec ${DOCKER_RUNNER_POD} -- docker push your-image:latest"
        //         }
        //     }
        // }
    }
}
