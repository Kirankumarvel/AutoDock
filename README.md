# 🚀 **AutoDock: Automated Docker Update & Cleanup**

AutoDock automates **Docker container updates** and **removes unused containers** to keep your system clean and optimized.

---

## 📌 **Features**
- **Automatically updates outdated Docker containers**
- **Removes unused containers, images & volumes**
- **Sends alerts via Email, Slack & Telegram**
- **Backup old container versions before updating**
- **Schedule automatic updates using cron jobs**

---

## 📂 **Project Structure**
```
AutoDock/
 ├── autodock.sh           # Main script to update & clean Docker containers
 ├── send_alerts.sh        # Sends alerts via Email, Slack & Telegram
 ├── setup.sh              # Installs dependencies & configures cron jobs
 ├── config.env            # Configuration file for repo & alert settings
 ├── README.md             # Project documentation
 ├── .gitignore            # Excludes sensitive files
 ├── logs/                 # Stores update & cleanup logs
 └── backup/               # Keeps old container versions before updating
```

---

## 🛠️ **Installation & Setup**

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/Kirankumarvel/AutoDock.git
cd AutoDock
```

### **2️⃣ Configure Environment Variables**
Edit the `config.env` file:
```bash
# Alert Settings
EMAIL_RECIPIENT="your-email@example.com"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/your/webhook/url"
TELEGRAM_BOT_TOKEN="your-telegram-bot-token"
TELEGRAM_CHAT_ID="your-telegram-chat-id"

# Docker Settings
CONTAINERS_TO_UPDATE=("nginx" "mysql" "redis")  # Containers to update
BACKUP_DIR="./backup"  # Directory to store old containers before update
```

### **3️⃣ Install Dependencies**
Run:
```bash
chmod +x setup.sh autodock.sh send_alerts.sh
./setup.sh
```

### 🚀 **Running AutoDock**
#### Run Once (Manual Execution)
```bash
./autodock.sh
```

#### Schedule with Cron (Daily at 2 AM)
```bash
crontab -e
```
Add this line:
```bash
0 2 * * * /path/to/autodock.sh >> /path/to/logs/autodock.log 2>&1
```

### 📧 **Testing Alerts**
```bash
./send_alerts.sh "Test Alert" "AutoDock Notification Test"
```

### 📜 **Future Enhancements**
- Add Discord & WhatsApp alerts
- Store update history in a database
- Implement a user-friendly web dashboard

### 📃 **License**
MIT License © 2025 Your Name

🚀 Keep your Docker environment clean & up-to-date with AutoDock!

---

### **🔧 `autodock.sh` (Main Script)**
```bash
#!/bin/bash
source config.env

echo "🚀 Starting AutoDock: Updating & Cleaning Docker Containers..."
echo "----------------------------------------------"

# Backup and Update Containers
for CONTAINER in "${CONTAINERS_TO_UPDATE[@]}"; do
    echo "📦 Backing up and updating $CONTAINER..."
    
    # Backup current container
    docker commit "$CONTAINER" "$BACKUP_DIR/${CONTAINER}_$(date +%Y-%m-%d).tar"

    # Pull latest image & restart container
    docker pull "$CONTAINER"
    docker stop "$CONTAINER"
    docker rm "$CONTAINER"
    docker run -d --name "$CONTAINER" "$CONTAINER"
done

# Remove unused images & volumes
echo "🧹 Cleaning up unused images & volumes..."
docker system prune -af

# Send alerts
./send_alerts.sh "AutoDock Update Complete" "Docker containers have been updated successfully."

echo "✅ AutoDock Process Completed!"
```

### 📧 **`send_alerts.sh` (Alert System)**
```bash
#!/bin/bash
source config.env

SUBJECT="$1"
MESSAGE="$2"

# Send Email
echo -e "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL_RECIPIENT"

# Send Slack Message
curl -X POST -H 'Content-type: application/json' --data \
    "{\"text\": \"*[$SUBJECT]*\n$MESSAGE\"}" "$SLACK_WEBHOOK_URL"

# Send Telegram Message
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" \
    -d text="*$SUBJECT*%0A$MESSAGE" \
    -d parse_mode="Markdown"

echo "📧 Alerts Sent: Email, Slack, and Telegram!"
```

### 🔧 **`setup.sh` (Setup & Cron Job)**
```bash
#!/bin/bash

echo "🔧 Installing dependencies..."
sudo apt update
sudo apt install -y docker.io curl mailutils

echo "🛠️ Setting up cron job..."
(crontab -l ; echo "0 2 * * * /path/to/autodock.sh >> /path/to/logs/autodock.log 2>&1") | crontab -

echo "✅ Setup Complete!"
```

### 📁 **.gitignore**
```
config.env
logs/*
backup/*
