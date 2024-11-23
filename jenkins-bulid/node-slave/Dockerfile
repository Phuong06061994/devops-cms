# Use a Node.js base image (Alpine version)
FROM node:18-alpine as node

# Install necessary tools, Docker CLI, and download the latest Jenkins Swarm client
RUN apk add --no-cache \
    wget \
    curl \
    git \
    bash \
    ca-certificates \
    && \
    # Install Docker CLI (Docker daemon isn't required since we're using the client)
    apk add --no-cache docker-cli && \
    # Download the Jenkins Swarm client
    wget -q -O /usr/local/bin/swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.44/swarm-client-3.44.jar && \
    chmod +x /usr/local/bin/swarm-client.jar

# Install Java from openjdk:17-slim (directly use this as the base)
FROM openjdk:17-slim as java

# Copy the swarm-client.jar from the node stage
COPY --from=node /usr/local/bin/swarm-client.jar /usr/local/bin/swarm-client.jar

# Install necessary tools to run the Swarm client (if not already included in the base image)
RUN apt-get update && \
    apt-get install -y curl wget git ca-certificates bash && \
    apt-get clean

# Set environment variables for Jenkins Swarm client configuration
ENV JENKINS_MASTER_URL=http://jenkins-master:8080 \
    SWARM_CLIENT_NAME=node-slave \
    SWARM_CLIENT_LABELS="node" \
    SWARM_CLIENT_EXECUTORS=2 \
    JENKINS_USERNAME=admin \
    JENKINS_PASSWORD=admin_password

# Ensure the swarm-client.jar file exists and is executable
RUN ls -l /usr/local/bin/swarm-client.jar && \
    chmod +x /usr/local/bin/swarm-client.jar

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to the shared script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
