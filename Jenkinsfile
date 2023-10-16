pipeline {
    agent { node { label 'AGENT-1'} }
    stages {
        stage('echo')
            steps {
                echo "HI iam a DOWNSTREAM JOB"
            }
    }
}