#!/bin/sh
set -e

# Docker daemon options
DOCKER_OPTS=""

# Ensure the Docker daemon is started with necessary configurations
if [ -z "$DOCKER_TLS_CERTDIR" ]; then
  DOCKER_OPTS="$DOCKER_OPTS --host=tcp://0.0.0.0:2375"
fi
echo "hello docker image"
# Execute the Docker daemon
exec dockerd $DOCKER_OPTS "$@"
