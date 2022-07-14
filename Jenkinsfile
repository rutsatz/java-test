pipeline {
    // Crio duas variáveis de ambiente.
    environment {
        // ID da nossa credencial cadastrada no Jenkins
        registryCredential = 'dockerhub'
        // Vai armazenar o nome da nova imagem criada pelo build.
        newApp = ''
    }

    agent { node {label 'jenkins-worker'}}

    stages {
        // Exemplo de como eu poderia editar um arquivo de properties usando o sed
        // O exemplo abaixo faz um replace no arquivo
        // sh "sed -i 's/DB_HOST.*/DB_HOST=database/g' .env.testing"
//         stage('Prepare env') {
//             steps {
//                 sh 'cp .env.example .env'
//                 sh "sed -i 's/DB_HOST.*/DB_HOST=database/g' .env.testing"
//                 sh "sed -i 's/DB_USERNAME.*/DB_USERNAME=homestead/g' .env.testing"
//                 sh "sed -i 's/DB_HOST.*/DB_HOST=database/g' .env"
//             }
//         }
        stage('Build') {
            steps {
                // Ao invés de usar o sh, eu posso usar o Docker Pipeline Plugin.
//                 sh 'docker build -t rutsatz/javatest:$BUILD_NUMBER .'
                script {
                    newApp = docker.build("rutsatz/javatest:$BUILD_NUMBER")
                }

            }
        }
        stage('Test') {
            steps {
                // Atualiza o docker compose com a tag da imagem que foi criada no estágio anterior
                // Ele procura pelo nome da imagem e troca a versão fixa v1 pela nova tag
                sh "sed -i 's/rutsatz\\/javatest.*/rutsatz\\/javatest:$BUILD_NUMBER/g' docker-compose.yml"
                sh "docker compose up -d"
//                 sh "docker exec app ./gradlew test"
                sh "docker compose down"
            }
        }
        stage('Push') {
            steps {
                script {
                     // Digo qual repositório de imagens vou usar e quais as credenciais para acessar
                     // esse repositório. Para saber qual Registry o docker está usando, posso executar:
                     // docker info
                     // E devo ver essa saída
                     //  Registry: https://index.docker.io/v1/
                     // Nesse caso, esse é o registry do dockerhub. E o segundo parâmetro é o ID
                     // da minha credencial.
                     docker.withRegistry('https://index.docker.io/v1/','dockerhub') {
                        newApp.push()
                     }
                }
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
