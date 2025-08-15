#!/bin/bash
# GitHub Codespaces Setup Script for New Relic Custom Visualization Workshop

set -e

echo "🚀 Setting up New Relic Custom Visualization Workshop in Codespaces..."

# Set up environment variables for development server
echo "export NR1_DEV_SERVER_HOST=0.0.0.0" >> ~/.bashrc
echo "export NR1_DEV_SERVER_PORT=3000" >> ~/.bashrc
echo "export WEBPACK_DEV_SERVER_HOST=0.0.0.0" >> ~/.bashrc
echo "export WEBPACK_DEV_SERVER_PORT=3000" >> ~/.bashrc

# Source the bashrc to make variables available immediately
source ~/.bashrc

echo "✅ Setup complete! You can now start developing your custom visualizations."