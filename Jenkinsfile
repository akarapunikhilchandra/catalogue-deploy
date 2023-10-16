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
                echo "params ${params.version}"
            }
        }

    }
}
