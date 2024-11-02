#!/bin/bash
# entrypoint.sh

# Start the Jenkins Swarm client with the provided environment variables
java -jar /usr/local/bin/swarm-client.jar \
  -master "${JENKINS_MASTER_URL}" \
  -name "${SWARM_CLIENT_NAME}" \
  -labels "${SWARM_CLIENT_LABELS}" \
  -executors "${SWARM_CLIENT_EXECUTORS}" \
  -username "${JENKINS_USERNAME}" \
  -password "${JENKINS_PASSWORD}"

