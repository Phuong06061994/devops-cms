#!/bin/bash

# Define the path to the initialAdminPassword file
FILE_PATH="/var/jenkins_home/secrets/initialAdminPassword"

# Check if the file exists and retrieve the password
if [ -f "$FILE_PATH" ]; then
  echo "Retrieving Jenkins admin password..."
  JENKINS_ADMIN_PASSWORD=$(cat "$FILE_PATH")
  echo "Admin password retrieved."
else
  JENKINS_USERNAME="phuongnv63"
  JENKINS_ADMIN_PASSWORD="123456"
  echo "File $FILE_PATH does not exist. Using default credentials..."
fi

# Ensure the Docker service is running if using Docker-in-Docker
# This is required only if you are using Docker inside the container (DinD)
if [ -f /usr/bin/docker ]; then
  echo "Docker found. Proceeding with Jenkins Swarm client execution..."
else
  echo "Docker not found. Skipping Docker service start..."
fi

# Execute Jenkins Swarm client with the necessary configuration
exec java -jar /usr/local/bin/swarm-client.jar \
      -master "${JENKINS_MASTER_URL}" \
      -labels "${SWARM_CLIENT_LABELS}" \
      -username "${JENKINS_USERNAME}" \
      -password "${JENKINS_ADMIN_PASSWORD}" \
      -name "${SWARM_CLIENT_NAME}" \
      -workDir "/home/jenkins" \
      -disableClientsUniqueId
