pipeline {
    agent { node {label 'jenkins-worker'}}

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t rutsatz/javatest:$BUILD_NUMBER .'
            }
            post {
                failure {
                    emailext subject: "Job '${env.JOB_NAME}' '${env.BUILD_NUMBER }' ",
                        body: "<p>Build failed at '${env.BUILD_URL}'</p>",
                        to: 'rafa.rutsatz@gmail.com'
                }
            }
        }
    }
}
