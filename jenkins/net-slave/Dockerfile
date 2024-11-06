FROM openjdk:17-jdk-slim
# Install necessary tools and Jenkins Swarm client
RUN apt-get update && \
    apt-get install -y wget curl git && \
    wget -q -O /usr/local/bin/swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.26/swarm-client-3.26.jar && \
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
