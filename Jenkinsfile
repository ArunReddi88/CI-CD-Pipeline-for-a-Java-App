pipeline {
    agent any

    tools {
        maven 'Maven-3.8.7'
        jdk 'JDK17'
    }

    environment {
        SONAR_TOKEN = credentials('sonartoken2') // Add in Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
               git branch: 'main', url: 'https://github.com/ArunReddi88/CI-CD-Pipeline-for-a-Java-App.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonar') {
                    sh 'mvn sonar:sonar -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }
      //
        stage('Docker Build') {
            steps {
                sh 'docker build -t demo-app-new .'
            }
        }
        stage('Docker Run') {
            steps {
                sh 'docker run -d -p 8085:8085 demo-app-new'
            }
        }
        //
    }
}
