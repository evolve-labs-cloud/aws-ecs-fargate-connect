#!/bin/bash

cd /home

sudo yum update -y
sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Create the script file
cat > ecs_connect.sh << 'EOF'
#!/bin/bash

DEF_CLUSTER=${ECS_CLUSTER_NAME}
CLUSTER_NAME=$2
if [ -z "$CLUSTER_NAME" ]; then
    CLUSTER_NAME=$DEF_CLUSTER
fi

SERVICE_NAME="svc-$1"
REGION=${ECS_REGION}
CONTAINER=$1
echo $CONTAINER

echo "Connect to cluster $CLUSTER_NAME add service $SERVICE_NAME"

TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service $SERVICE_NAME --region $REGION --output text --query 'taskArns[0]')
echo $TASK_ARN

aws ecs execute-command --region $REGION --cluster $CLUSTER_NAME --task $TASK_ARN --container $CONTAINER --command "sh" --interactive
EOF

chmod +x ecs_connect.sh