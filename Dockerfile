# Step 1: Build the React app using Node.js
FROM node:20-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the app's source code
COPY . .

# Build the React app for production
RUN npm run build

# Step 2: Serve the React app using Nginx
FROM nginx:alpine

# Copy the build files from the build stage to Nginx's HTML folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 (default for Nginx)
EXPOSE 80

# Custom Nginx config for React Router support (if needed)
COPY nginx.conf /etc/nginx/nginx.conf

# Start Nginx to serve the build files
CMD ["nginx", "-g", "daemon off;"]
