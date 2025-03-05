#!/bin/bash

# Load configuration
source config.env

SUBJECT="$1"
MESSAGE="$2"

# Function to send Email alert
send_email() {
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL_RECIPIENT"
}

# Function to send Slack alert
send_slack() {
    curl -X POST -H 'Content-type: application/json' --data \
    "{\"text\": \"*[$SUBJECT]*\n$MESSAGE\"}" "$SLACK_WEBHOOK_URL"
}

# Function to send Telegram alert
send_telegram() {
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="*$SUBJECT*%0A$MESSAGE" \
        -d parse_mode="Markdown"
}

# Send alerts
send_email
send_slack
send_telegram

echo "Alerts sent via Email, Slack, and Telegram."
