#!/bin/bash

# Set log file path
LOG_FILE="/var/log/user-data.log"

# Function to log messages
log_message() {
    echo "$(date): $1" >> $LOG_FILE
}

# Function to run command and log output
run_command() {
    $@ >> $LOG_FILE 2>&1
}

# Start installation
log_message "Starting Apache2 installation"

# Update and install Apache2
run_command sudo apt update
run_command sudo apt install apache2 -y

# Configure Apache2 service
run_command sudo systemctl start apache2
run_command sudo systemctl enable apache2

# Create test page
echo "<html><body><h1>Apache2 Test Page</h1></body></html>" | sudo tee /var/www/html/index.html

# Log completion
log_message "Apache2 installation completed"
