#!/bin/bash

echo "🔧 Installing dependencies..."
sudo apt update
sudo apt install -y docker.io curl mailutils

echo "🛠️ Setting up cron job..."
(crontab -l ; echo "0 2 * * * /path/to/autodock.sh >> /path/to/logs/autodock.log 2>&1") | crontab -

echo "✅ Setup Complete!"
