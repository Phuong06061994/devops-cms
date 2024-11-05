# Use the official Jenkins LTS image
FROM jenkins/jenkins:lts

# Switch to the root user to install plugins
USER root

RUN apt-get update && apt-get install -y jq

# Install necessary packages for managing Jenkins plugins
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Switch back to the Jenkins user
USER jenkins

# Install the Swarm plugin and any other necessary plugins using the Jenkins CLI
RUN jenkins-plugin-cli --plugins swarm:latest

RUN jenkins-plugin-cli --plugins instance-identity:185.v303dc7c645f9

# Expose the necessary ports
EXPOSE 8080 50000

# Start Jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
