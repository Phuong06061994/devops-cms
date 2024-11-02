# Use the .NET 8 SDK as the base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Install necessary tools and Java 17
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jdk git curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install the Jenkins Swarm client
RUN wget -q -O /usr/local/bin/swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.26/swarm-client-3.26.jar && \
    chmod +x /usr/local/bin/swarm-client.jar

# Set environment variables for Jenkins Swarm client configuration
ENV JENKINS_MASTER_URL=http://jenkins-master:8080 \
    SWARM_CLIENT_NAME=net-slave \
    SWARM_CLIENT_LABELS="net" \
    SWARM_CLIENT_EXECUTORS=2 \
    JENKINS_USERNAME=admin \
    JENKINS_PASSWORD=admin_password

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to the shared script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]