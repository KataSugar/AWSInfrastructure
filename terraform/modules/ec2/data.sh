#!/bin/bash
# Update and install dependencies
yum update -y
curl -sL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs

# Create app directory
mkdir -p /app
cd /app

# Install npm dependencies
npm init -y
npm install express
npm install -g pm2

# Start the app with using a process manager(PM2)
pm2 start /app/server.js
pm2 startup
pm2 save
