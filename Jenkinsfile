pipeline {
    environment {
        registryCredential = 'dockerhub'
        newApp = ''
    }
    agent { node { label 'jenkins-worker' } }
    parameters {
        choice(name: 'target_environment',
            choices: 'dev\nprod',
            description: 'Environment')
        choice(name: 'branch',
            choices: 'main',
            description: 'Branch')
        string(name: 'version',
            defaultValue: '',
            description: 'Version')
    }
    stages {
        stage('Build') {
            steps {
                script {
                    newApp = docker.build("rutsatz/javatest:$BUILD_NUMBER")
                }
            }
        }
        stage('Test') {
            steps {
                sh "sed -i 's/rutsatz\\/javatest.*/rutsatz\\/javatest:$BUILD_NUMBER/g' docker-compose.yml"
                sh "docker compose up -d"
                sh "docker compose down"
            }
        }
        stage('Push') {
            steps {
                script {
                     docker.withRegistry('https://index.docker.io/v1/','dockerhub') {
                        newApp.push()
                     }
                }
            }
        }
        stage('Deploy'){
            steps{
                sh 'kubectl set image deployment/spring-app backend=rutsatz/javatest:$BUILD_NUMBER -n default --kubeconfig /home/jenkins/.kube/config'
            }
        }

//             post {
//                 failure {
//                     emailext subject: "Job '${env.JOB_NAME}' '${env.BUILD_NUMBER }' ",
//                         body: "<p>Build failed at '${env.BUILD_URL}'</p>",
//                         to: 'rafa.rutsatz@gmail.com'
//                 }
//             }

    }
}
