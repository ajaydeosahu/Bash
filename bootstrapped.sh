#!/bin/bash -x
cd /home/ubuntu
sudo ./install auto 
sudo systemctl restart codedeploy-agent.service
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:production-cloudwatch
echo "nginx soft nofile 4096" >> /etc/security/limits.conf
echo "nginx hard nofile 64000" >> /etc/security/limits.conf
systemctl daemon-reload
sudo find /var/log/nginx -type f -exec chmod g+wx,o+r '{}' + -o -type d -exec chmod g+rwx,o+rx '{}' +
sudo systemctl restart nginx
sudo usermod -p 'ubuntu' ssm-user
