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
    parameters {
        string(name: 'version', defaultValue: '1.0.0', description: 'Who should I say hello to?')
    }
    stages {
        stage('echo') {
            steps {
                echo "HI I am a DOWNSTREAM JOB"
            }
        }
        stage('deploy') {
            steps {
                script {
                    echo "params $params.version"
                def params = [
                    string(name: 'version',value: $packageVersion)
                ]
                build job: "../catalogue-deploy",wait: true, parameters: params
                }
            }
        }
    }
}
