#!/bin/bash

## Send messages using incoming webhooks
WEBHOOK_URL="https://hooks.slack.com/services/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"
#curl -X POST --data-urlencode "payload={\"channel\": \"#me_roypark22_new\", \"username\": \"mydemo-webhook\", \"text\": \"이 항목은 #개의 my-channel-here에 포스트되며 webhookbot이라는 봇에서 제공됩니다.\", \"icon_emoji\": \":ghost:\"}" $WEBHOOK_URL
curl -X POST --data-urlencode "payload={\"channel\": \"#me_roypark22_hook\", \"username\": \"webhookbot\", \"text\": \"이 항목은 #개의 my-channel-here에 포스트되며 webhookbot이라는 봇에서 제공됩니다.\", \"icon_emoji\": \":ghost:\"}" $WEBHOOK_URL

## Initialize log file
cat /dev/null > /home/ec2-user/deploy.log

## Deploy Java Service
BUILD_JAR=$(ls /home/ec2-user/mydemo-deploy/build/libs/sbb-0.0.1-SNAPSHOT.jar)
JAR_NAME=$(basename $BUILD_JAR)
echo "> build : $JAR_NAME" >> /home/ec2-user/deploy.log

echo "> build 파일 복사" >> /home/ec2-user/deploy.log
DEPLOY_PATH=/home/ec2-user/
cp $BUILD_JAR $DEPLOY_PATH

echo "> 실행중인 애플리케이션 pid 확인" >> /home/ec2-user/deploy.log
CURRENT_PID=$(pgrep -f $JAR_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 실행중인 애플리케이션이 없으므로 종료하지 않음" >> /home/ec2-user/deploy.log
else
  echo "> kill -9 $CURRENT_PID" >> /home/ec2-user/deploy.log
  kill -9 $CURRENT_PID
  sleep 10;
fi

DEPLOY_JAR=$DEPLOY_PATH$JAR_NAME
echo "> DEPLOY_JAR 배포"    >> /home/ec2-user/deploy.log
nohup java -jar $DEPLOY_JAR >> /home/ec2-user/deploy.log 2>/home/ec2-user/deploy_err.log &