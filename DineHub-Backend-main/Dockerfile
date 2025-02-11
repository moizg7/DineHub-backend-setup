# Use Alpine as the base image
FROM node:22-alpine
# # Verify Node.js and npm installation
# RUN node -v
# RUN npm -v

# Set the working directory in the container
WORKDIR /app/backend

# Copy the contents of the current directory to the working directory in the container
COPY ./ /app/backend

# # Install dependencies for the app
RUN npm install

# Expose port 3000
EXPOSE 3000

# Define the command to run your application
ENTRYPOINT ["npm", "run", "dev"]
