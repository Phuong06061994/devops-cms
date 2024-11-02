#!/bin/sh

# Ensure all necessary environment variables are set
if [ -z "$JENKINS_URL" ] || [ -z "$JENKINS_USER" ] || [ -z "$JENKINS_PASSWORD" ] || [ -z "$NEW_TOKEN_NAME" ]; then
  echo "One or more required environment variables are missing."
  echo "Please set JENKINS_URL, JENKINS_USER, JENKINS_PASSWORD, and NEW_TOKEN_NAME."
  exit 1
fi

# Get API Token from Jenkins
API_TOKEN=$(curl -s -X POST "$JENKINS_URL/user/$JENKINS_USER/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken" \
  --user "$JENKINS_USER:$JENKINS_PASSWORD" \
  --data-urlencode "newTokenName=$NEW_TOKEN_NAME")

# Debugging: Print raw response (comment out in production)
# echo "Response: $API_TOKEN"

# Check for errors in the API response
if echo "$API_TOKEN" | grep -q '"tokenValue":'; then
  # Extract the token value using grep
  API_TOKEN=$(echo "$API_TOKEN" | grep -oP '(?<=tokenValue":")(.*?)(?=")')

  # Save API token to shared file
  echo "$API_TOKEN" > /shared/jenkins_api_token
  echo "Generated API token and saved to /shared/jenkins_api_token"
else
  echo "Failed to generate a new API token. Response: $API_TOKEN"
  exit 1
fi

