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
