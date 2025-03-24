# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy application code
COPY . .

# Build the NestJS app
RUN npm run build

# Expose the port that NestJS runs on
EXPOSE 8080

# Command to start the application
CMD ["npm", "run", "start:prod"]
