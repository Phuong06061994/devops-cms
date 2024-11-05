FROM jenkins/inbound-agent:latest

# Set the working directory
WORKDIR /home/reactApp

# Copy all source code to /home/reactApp
COPY . .

USER root

# Install Node.js, Java, Maven, and other dependencies
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs jq openjdk-17-jdk maven curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Set the environment variable for Jenkins URL
ENV JENKINS_URL=http://jenkins-master:8080

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
