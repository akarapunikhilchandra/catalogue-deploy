// pipeline {
//     agent { node { label 'AGENT-1'} }
//     stages {
//         stage('echo')
//             steps {
//                 echo "HI iam a DOWNSTREAM JOB"
//             }
//     }
// }

pipeline {
    agent { node { label 'AGENT-1' } }
    options {
        ansiColor('xterm')
    }
    parameters {
        string(name: 'version', defaultValue: '1.0.0', description: 'which version to deploy ?')
    }
    stages {
        stage('echo') {
            steps {
                echo "params ${params.version}"
            }
        }
        stage('Init'){
            steps{
                sh '''
                cd terraform
                terraform init -upgrade
                terraform init -reconfigure
                
                '''
            }
        }
        stage('Plan'){
            steps{
                sh '''
                cd terraform
                terraform plan 
                '''
            }
        }
        stage('destroy'){
            steps{
                sh '''
                terraform destroy -auto-approve
                '''
            }
        }

    }
}
