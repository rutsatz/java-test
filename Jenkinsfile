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
            defaultValue: "0.${env.BUILD_NUMBER}.rc",
            description: 'Version')
    }
    stages {
        stage('Build') {
            steps {
                script {
                    newApp = docker.build("rutsatz/javatest:${params.version}")
                }
            }
        }
        stage('Test') {
            steps {
                sh "sed -i \"s/rutsatz\\/javatest.*/rutsatz\\/javatest:${params.version}/g\" docker-compose.yml"
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
        stage('Deploy to Dev') {
            when {
                expression {params.target_environment == 'dev'}
            }
            steps {
                sh "kubectl set image deployment/spring-app backend=rutsatz/javatest:${params.version}"
            }
        }
        stage('Deploy to Prod') {
            when {
                beforeInput true
                expression {params.target_environment == 'prod'}
            }
            input {
                message "Deploy to prod?"
                ok "Submit"
            }
            steps {
                sh "kubectl set image deployment/spring-app backend=rutsatz/javatest:${params.version}"
            }
            post {
                success {
                    emailext subject: "Job '${env.JOB_NAME}' '${env.BUILD_NUMBER }' ",
                        body: "<p>Build deployed to prod at '${env.BUILD_URL}'</p>",
                        to: 'rafa.rutsatz@gmail.com'
                }
                failure {
                    emailext subject: "Job '${env.JOB_NAME}' '${env.BUILD_NUMBER}' ",
                        body: "<p>Build failed at '${env.BUILD_URL}'</p>",
                        to: 'rafa.rutsatz@gmail.com'
                }
            }
        }
    }
}
