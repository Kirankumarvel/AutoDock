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
