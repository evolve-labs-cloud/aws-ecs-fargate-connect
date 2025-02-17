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

SERVICE_NAME="$1"
REGION=${ECS_REGION}

if [ -z "$SERVICE_NAME" ]; then
    echo "Usage: $0 <service-name> [cluster-name]"
    exit 1
fi

echo "Input parameters:"
echo "  Service name: $SERVICE_NAME"
echo "  Cluster: $CLUSTER_NAME"

# Get task ARN
TASK_ARN=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service $SERVICE_NAME --region $REGION --output text --query 'taskArns[0]')
if [ -z "$TASK_ARN" ]; then
    echo "Error: No running tasks found for service $SERVICE_NAME"
    exit 1
fi
echo "Task ARN: $TASK_ARN"

# Get and display available containers
echo "Checking available containers..."
CONTAINERS=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $TASK_ARN --region $REGION --query 'tasks[0].containers[*].name' --output text)
echo "Available containers in task:"
echo "$CONTAINERS"

# Let user choose container
echo ""
echo "Which container would you like to connect to?"
read -p "Enter container name: " CONTAINER

# Verify container exists
if ! echo "$CONTAINERS" | grep -q "\b$CONTAINER\b"; then
    echo "Error: Container '$CONTAINER' not found in task"
    echo "Available containers are: $CONTAINERS"
    exit 1
fi

# Try to connect
echo "Attempting to connect to container '$CONTAINER'..."
aws ecs execute-command \
    --region $REGION \
    --cluster $CLUSTER_NAME \
    --task $TASK_ARN \
    --container "$CONTAINER" \
    --command "sh" \
    --interactive
EOF

chmod +x ecs_connect.sh