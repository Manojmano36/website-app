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
          env.GIT_SHA = sh(
            script: "git rev-parse --short HEAD",
            returnStdout: true
          ).trim()
        }
        echo "Git SHA is ${env.GIT_SHA}"
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${GIT_SHA} ."
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
            docker push ${IMAGE_NAME}:${GIT_SHA}
          """
        }
      }
    }

    stage('Update GitOps Repo') {
  steps {
    withCredentials([usernamePassword(
      credentialsId: 'github-creds',
      usernameVariable: 'GIT_USER',
      passwordVariable: 'GIT_TOKEN'
    )]) {
      sh """
        rm -rf website-k8s
        git clone https://${GIT_USER}:${GIT_TOKEN}@github.com/Manojmano36/website-k8s.git
        cd website-k8s

        echo "Updating image to ${IMAGE_NAME}:${GIT_SHA}"
        sed -i "s|image:.*|image: ${IMAGE_NAME}:${GIT_SHA}|" deployment.yaml

        git config user.email "ci-bot@jenkins"
        git config user.name "jenkins-bot"

        git add deployment.yaml
        git commit -m "Deploy image ${GIT_SHA}" || echo "No changes to commit"
        git push
      """
    }
  }
}
🧪 
  }
}
