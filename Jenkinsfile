pipeline {
    agent any

    environment {
        PROJECT_ID = 'tu-proyecto-gcp'
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
                sh 'docker build -t $GCR_HOSTNAME/$PROJECT_ID/$IMAGE_NAME:latest .'
            }
        }

        stage('Push Image to GCR') {
            steps {
                sh '''
                gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                gcloud auth configure-docker gcr.io
                docker push $GCR_HOSTNAME/$PROJECT_ID/$IMAGE_NAME:latest
                '''
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
