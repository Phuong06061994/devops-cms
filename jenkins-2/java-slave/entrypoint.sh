#!/bin/bash

# Fail fast on errors
set -e

# Wait for Jenkins master to be ready
echo "Waiting for Jenkins master to be ready..."
until curl -s "${JENKINS_URL}/login" > /dev/null; do
    sleep 5
done

# Wait a little longer to ensure Jenkins is fully initialized
echo "Waiting for Jenkins master to fully initialize..."
sleep 10  # Adjust this time as necessary

# Start the Java application using Maven
echo "Starting Java app with Maven..."
cd /home/javaApp || { echo "Directory /home/javaApp not found. Exiting."; exit 1; }
mvn spring-boot:run &

# Retrieve the initial admin password
JENKINS_ADMIN_PASSWORD=$(cat /var/jenkins_home/secrets/initialAdminPassword)

# Download the Swarm client if it doesn't exist
SWARM_CLIENT_JAR="/usr/share/jenkins/swarm-client.jar"
if [ ! -f "$SWARM_CLIENT_JAR" ]; then
    echo "Downloading Swarm client..."
    curl -o "$SWARM_CLIENT_JAR" "${JENKINS_URL}/swarm/swarm-client.jar"
fi

# Ensure the Swarm client was downloaded successfully
if [ ! -f "$SWARM_CLIENT_JAR" ]; then
    echo "Error: Unable to access jarfile $SWARM_CLIENT_JAR. Exiting."
    exit 1
fi

AGENT_NAME="java-slave"

# Start the Jenkins agent using JNLP (Java Network Launch Protocol)
echo "Starting Jenkins agent..."
java -jar "$SWARM_CLIENT_JAR" \
    -master "${JENKINS_URL}" \
    -username "admin" \
    -password "${JENKINS_ADMIN_PASSWORD}" \
    -name "${AGENT_NAME}" \
    -workDir "/home/jenkins"

# Check if the agent started successfully
if [ $? -ne 0 ]; then
    echo "Failed to start Jenkins agent. Exiting."
    exit 1
fi

echo "Jenkins agent started successfully."


# Optional: If you want to keep this script running, you might want to add a wait command
# while true; do sleep 1000; done
