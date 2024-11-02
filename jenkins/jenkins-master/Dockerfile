FROM jenkins/jenkins:lts

# Switch to root user
USER root

# Install the Swarm plugin using jenkins-plugin-cli
RUN jenkins-plugin-cli --plugins swarm

# Expose Jenkins default ports
EXPOSE 8080 50000

# Set environment variables for initial admin user setup
ENV JENKINS_ADMIN_ID=admin
ENV JENKINS_ADMIN_PASSWORD=admin_password

