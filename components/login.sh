#!/bin/bash

source components/common.sh
OS_PREREQ
#DN="zsdevops01.xyz"

Head "Installing Golang"
apt install golang -y &>>$LOG
Check $?

DOWNLOAD_COMPONENT

Head "Extract Downloaded Archive"
cd /home/ubuntu && rm -rf login && apt install unzip && unzip /tmp/login.zip &>>$LOG && mv login-main login && cd /home/ubuntu/login && export GOPATH=/home/ubuntu/go && export GOBIN=$GOPATH/bin && go get &>>$LOG && go build
Check $?

#Head "pass the EndPoints in Service File"
#sed -i -e "s/user_endpoint/user.${DN}/" /home/ubuntu/login/systemd.service
#Check $?

Head "Setup the systemd Service"
mv /home/ubuntu/login/systemd.service /etc/systemd/system/login.service && systemctl daemon-reload && systemctl start login && systemctl enable login &>>$LOG
Check $?