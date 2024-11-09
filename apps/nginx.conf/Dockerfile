# Use the official NGINX image
FROM nginx:latest

# Copy the custom entrypoint script
COPY nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh

# Make the script executable
RUN chmod +x /usr/local/bin/nginx-entrypoint.sh

# Set the entrypoint to run the custom script
ENTRYPOINT ["sh", "/usr/local/bin/nginx-entrypoint.sh"]
