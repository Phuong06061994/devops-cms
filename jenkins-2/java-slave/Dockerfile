FROM jenkins/inbound-agent:latest

# Set the working directory
WORKDIR /home/javaApp

# Copy all source code to /home/javaApp
COPY . .

USER root

# Install Java JDK and Maven
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven && \
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

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
