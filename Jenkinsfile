pipeline {
    agent {
        kubernetes {
            label 'jenkins-docker-agent'
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:latest
    command: ["cat"]
    tty: true
    volumeMounts:
      - name: docker-socket
        mountPath: /var/run/docker.sock
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }

    environment {
        PROJECT_ID = 'SportResult'
        GCR_HOSTNAME = 'gcr.io'
        IMAGE_NAME = 'mi-app'
        CLUSTER_NAME = 'jenkins-cluster'
        GKE_ZONE = 'us-central1-a'
        K8S_NAMESPACE = 'default'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials', url: 'https://github.com/mimoshin/JenkinsTest.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh 'docker pull fvegautentia/base-app:1.0'
                    sh 'docker build -t fvegautentia/base-app:1.0'
                }
            }
        }

        stage('Push Image to GCR') {
            steps {
                container('docker') {
                    sh '''
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                    gcloud auth configure-docker gcr.io
                    docker push $GCR_HOSTNAME/$PROJECT_ID/$IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                gcloud container clusters get-credentials $CLUSTER_NAME --zone $GKE_ZONE
                kubectl set image deployment/mi-app mi-app=$GCR_HOSTNAME/$PROJECT_ID/$IMAGE_NAME:latest
                '''
            }
        }
    }
}
