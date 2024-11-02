#!/bin/bash

# Wait for Jenkins to be up and running
while ! curl -s -o /dev/null http://localhost:8080/login; do
    echo "Waiting for Jenkins to start..."
    sleep 5
done

# Variables
AGENT_NAME="java-slave-938c5d46"
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_PASSWORD="admin_password"

# Create the agent using Jenkins API
curl -X POST "${JENKINS_URL}/computer/doCreateItem?name=${AGENT_NAME}" \
    --user ${JENKINS_USER}:${JENKINS_PASSWORD} \
    -H "Content-Type: application/xml" \
    -d "<slave>
            <name>${AGENT_NAME}</name>
            <description>Java slave agent</description>
            <remoteFS>/var/jenkins/slave</remoteFS>
            <numExecutors>2</numExecutors>
            <label></label>
            <mode>normal</mode>
            <launcher>
                <jnlpLauncher/>
            </launcher>
         </slave>"

