# Use a lightweight Nginx image as the base
FROM nginx:1.21-alpine

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy your app's files to the Nginx document root
COPY . /usr/share/nginx/html

# Expose the desired port (e.g., 80)
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
