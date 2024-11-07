#!/bin/bash

# Define the path to the initialAdminPassword file
FILE_PATH="/var/jenkins_home/secrets/initialAdminPassword"

# Check if the file exists
if [ -f "$FILE_PATH" ]; then
  # Read and store the contents of the file
  echo "Retrieving Jenkins admin password..."
  JENKINS_ADMIN_PASSWORD=$(cat "$FILE_PATH")
  echo "Admin password retrieved: $JENKINS_ADMIN_PASSWORD"
else
  JENKINS_USERNAME="phuongnv63"
  JENKINS_ADMIN_PASSWORD="123456"
  echo "File $FILE_PATH does not exist. Exiting..."
fi

exec java -jar /usr/local/bin/swarm-client.jar \
      -master "${JENKINS_MASTER_URL}" \
      -labels "${SWARM_CLIENT_LABELS}" \
      -username "${JENKINS_USERNAME}" \
      -password "${JENKINS_ADMIN_PASSWORD}" \
      -name "${SWARM_CLIENT_NAME}" \
      -workDir "/home/jenkins"
