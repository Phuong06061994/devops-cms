FROM jenkins/jenkins:lts

# Switch to root user
USER root

# Install the Swarm plugin using jenkins-plugin-cli
RUN jenkins-plugin-cli --plugins swarm

# Copy initialization script(s) into the correct directory
COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d/

# Change the permissions to allow the Jenkins user to execute the init scripts
RUN chmod 755 /usr/share/jenkins/ref/init.groovy.d/init.groovy

# Expose Jenkins default ports
EXPOSE 8080 50000

# Set environment variables for initial admin user setup
ENV JENKINS_ADMIN_ID=admin
ENV JENKINS_ADMIN_PASSWORD=admin_password

# Note: Do not override the entrypoint
# The default entrypoint of the Jenkins image should be used
