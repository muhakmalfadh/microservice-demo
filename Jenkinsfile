pipeline {
    agent any

    environment {
        DOCKER_RUNNER_POD = 'docker-runner'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "kubectl exec ${DOCKER_RUNNER_POD} -- docker ps"
                }
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
