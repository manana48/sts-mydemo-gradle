pipeline {
    agent any
    
    options {
        timeout(time: 1, unit: 'HOURS') // set timeout 1 hour
    }
    
    environment {
        GIT_CREDENTIALS_ID = 'mydemo-git-credential'
        GIT_URL = 'https://gitlab-bk.kakaovx.net/infra/mydemo-project.git'
        TARGET_BRANCH = 'main'
        //ECR_URL = '293861751646.dkr.ecr.us-east-1.amazonaws.com'
        //ECS_CLUSTER_NAME = 'mydemo-ecs-cluster'
        //ECS_SERVICE_NAME = 'mydemo-ecs-service-node'
    }

    stages {
        stage('Git Clone') {
            steps {
                script {
                    try {
                        git url: "$GIT_URL", branch: "$TARGET_BRANCH", credentialsId: "$GIT_CREDENTIALS_ID"
                        sh "rm -rf ./.git"
                        env.cloneResult=true
                    } catch (error) {
                        print(error)
                        env.cloneResult=false
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
        stage('Java Build') {
            steps {
                script {
                    try {
                        //withAWS(region: 'us-east-1', credentials: 'mydemo-user') {
                        //steps {
                        sh 'chmod +x gradlew'
                        sh './gradlew build --exclude-task test'
                    } catch (error) {
                        print(error)
                        echo 'Remove Deploy Files'
                        sh "rm -rf /var/lib/jenkins/workspace/${env.JOB_NAME}/*"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
            post {
                success {
                    echo "The Java Build stage successfully."
                }
                failure {
                    echo "The Java Build stage failed."
                }
            }
        }
        stage('Deploy'){
            steps {
                script{
                    try {
                        //withAWS(region: 'us-east-1', credentials: 'mydemo-user') {
                        //steps {
                        step([$class: 'AWSCodeDeployPublisher', applicationName: 'BK-WEB-APP', awsAccessKey: 'XXXXXXXX', awsSecretKey: 'XXXXXXXXX', credentials: 'awsAccessKey', deploymentConfig: 'CodeDeployDefault.OneAtATime', deploymentGroupAppspec: false, deploymentGroupName: 'BK-WEB-DEPLOY-GROUP', deploymentMethod: 'deploy', excludes: '', iamRoleArn: '', includes: '**/*.jar, **/appspec.yml, **/scripts/', proxyHost: '', proxyPort: 0, region: 'ap-northeast-2', s3bucket: 'bk-web-codedeploy-s3', s3prefix: '', subdirectory: '', versionFileName: '', waitForCompletion: false])
                    } catch (error) {
                        print(error)
                        echo 'Remove Deploy Files'
                        sh "rm -rf /var/lib/jenkins/workspace/${env.JOB_NAME}/*"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
            post {
                success {
                    echo "The deploy stage successfully."
                }
                failure {
                    echo "The deploy stage failed."
                }
            }
        }
    }
}