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
        stage('Copy Jar to EC2') {
            steps {
                sshagent (credentials: ['ec2-ssh-key']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no target/demo-0.0.1-SNAPSHOT.jar ubuntu@23.22.32.187:/home/ubuntu/demo-app/app.jar
                    '''
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent (credentials: ['ec2-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@23.22.32.187 '
                      docker rm -f demo-app || true
                      docker run -d -p 8085:8085 --name demo-app -v /home/ubuntu/demo-app/app.jar:/app/app.jar openjdk:17 java -jar /app/app.jar
                    '
                    '''
                }
            }
        }

        
    }
}
