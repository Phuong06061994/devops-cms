# Frontend Dockerfile

# Use a Node.js base image
FROM node:18-alpine AS frontend

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json (if they exist) into the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the frontend files
COPY . .

# Expose the port for the frontend app (e.g., 3000 for React)
EXPOSE 3000

# Run the frontend app
CMD ["npm", "start"]
