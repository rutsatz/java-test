pipeline {
    agent { node {label 'jenkins-worker'}}

    stages {
        stage('Build') {
            steps {
                // Exemplo de como eu poderia editar um arquivo de properties usando o sed
                // O exemplo abaixo faz um replace no arquivo
                // sh "sed -i 's/DB_HOST.*/DB_HOST=database/g' .env.testing"
                sh 'docker build -t rutsatz/javatest:$BUILD_NUMBER .'
            }
        }
        stage('Test') {
            steps {
                // Atualiza o docker compose com a tag da imagem que foi criada no estágio anterior
                // Ele procura pelo nome da imagem e troca a versão fixa v1 pela nova tag
                sh "sed -i 's/rutsatz\\/javatest.*/rutsatz\\/javatest:$BUILD_NUMBER/g' docker-compose.yml"
                sh "docker compose up -d"
//                 sh "docker exec app ./gradlew test"
                sh "docker-compose down"
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
}
