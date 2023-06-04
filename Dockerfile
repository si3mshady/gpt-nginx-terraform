# Use a lightweight Node.js image as the base
FROM node:14-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the application files to the container
COPY index.html index.js index.css /app/

# Expose the desired port (e.g., 8080)
EXPOSE 8080

# Install any dependencies (if your application requires)
# RUN npm install

# Define the command to run your application
CMD ["node", "index.js"]
