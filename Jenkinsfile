pipeline {
  agent any

  environment {
    IMAGE_NAME = "manojmano36/website-app"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Test') {
      steps {
        sh 'chmod +x tests/test.sh'
        sh './tests/test.sh'
      }
    }

    stage('Get Git Commit') {
      steps {
        script {
          GIT_SHA = sh(
            script: "git rev-parse --short HEAD",
            returnStdout: true
          ).trim()
        }
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t $IMAGE_NAME:${GIT_SHA} ."
      }
    }

    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh """
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE_NAME:${GIT_SHA}
          """
        }
      }
    }
  }
}
