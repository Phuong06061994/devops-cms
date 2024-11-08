FROM openjdk:17-jdk-slim

# Install necessary tools, Docker, and download the latest Jenkins Swarm client
RUN apt-get update && \
    apt-get install -y wget curl git apt-transport-https ca-certificates lsb-release && \
    # Add Docker's official GPG key and setup the Docker stable repository
    curl -fsSL https://download.docker.com/linux/debian/gpg | tee /etc/apt/trusted.gpg.d/docker.asc && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    # Download the Jenkins Swarm client
    wget -q -O /usr/local/bin/swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.44/swarm-client-3.44.jar && \
    chmod +x /usr/local/bin/swarm-client.jar && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Jenkins Swarm client configuration
ENV JENKINS_MASTER_URL=http://jenkins-master:8080 \
    SWARM_CLIENT_NAME=java-slave \
    SWARM_CLIENT_LABELS="java" \
    SWARM_CLIENT_EXECUTORS=2 \
    JENKINS_USERNAME=admin \
    JENKINS_PASSWORD=admin_password

# Copy entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to use the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
