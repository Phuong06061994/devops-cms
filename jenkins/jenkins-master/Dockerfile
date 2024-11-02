FROM jenkins/jenkins:lts

# Switch to root user
USER root

# Install required plugins
RUN jenkins-plugin-cli --plugins swarm matrix-auth

# Install required packages and sdkman
RUN apt-get update && \
    apt-get install -y curl unzip zip && \
    rm -rf /var/lib/apt/lists/*

# Install sdkman
RUN curl -s "https://get.sdkman.io" | bash && \
    bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install groovy 3.0.9"

# Set Groovy environment variables
ENV GROOVY_HOME="/root/.sdkman/candidates/groovy/current"
ENV PATH="${GROOVY_HOME}/bin:${PATH}"

# Install the Swarm plugin using jenkins-plugin-cli
RUN jenkins-plugin-cli --plugins swarm

# Display the contents of init.groovy before copying (assuming it is already created in the build context)
RUN if [ -f init.groovy ]; then cat init.groovy; else echo "init.groovy not found"; fi

# Copy initialization script(s) into the correct directory
COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d/

# Display the contents of init.groovy after copying
RUN if [ -f /usr/share/jenkins/ref/init.groovy.d/init.groovy ]; then cat /usr/share/jenkins/ref/init.groovy.d/init.groovy; else echo "init.groovy not found in the target directory"; fi

# Change the permissions to allow the Jenkins user to execute the init scripts
RUN chmod 755 /usr/share/jenkins/ref/init.groovy.d/init.groovy

# Expose Jenkins default ports
EXPOSE 8080 50000

# Set environment variables for initial admin user setup
ENV JENKINS_ADMIN_ID=admin
ENV JENKINS_ADMIN_PASSWORD=admin_password

