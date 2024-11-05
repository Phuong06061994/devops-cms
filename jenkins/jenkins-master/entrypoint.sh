#!/bin/bash

# Fail fast on errors
set -e

# Function to install Jenkins plugins
install_plugins() {
    echo "Installing suggested plugins..."
    
    # Create a plugins.txt file for suggested plugins
    PLUGIN_LIST="/usr/share/jenkins/plugins.txt"

    # Fetch the list of suggested plugins
    curl -s "http://updates.jenkins.io/stable/update-center.json" | \
    jq -r '.plugins | to_entries[] | select(.value.suggested==true) | .key' > "$PLUGIN_LIST"

    # Install plugins using jenkins-plugin-cli
    /usr/local/bin/jenkins-plugin-cli --plugins "$(cat $PLUGIN_LIST | tr '\n' ',')"

    echo "All suggested plugins installed successfully."
}

# Start Jenkins in the background
java -jar /usr/share/jenkins/jenkins.war &

# Wait for Jenkins to start
echo "Waiting for Jenkins to start..."
until curl -s "http://localhost:8080/login" > /dev/null; do
    sleep 5
done

# Install plugins after Jenkins has started
install_plugins

# Bring Jenkins to the foreground
wait
