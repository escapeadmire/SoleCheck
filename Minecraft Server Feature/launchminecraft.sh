#!/bin/bash
# Start Minecraft Server in a screen session

# Change to the directory where the Minecraft server is located
cd /home/minecraft/Minecraft || { echo "Directory not found"; exit 1; }

# Check if the Minecraft server jar file exists
if [ ! -f "server.jar" ]; then
    echo "Minecraft server JAR file not found!"
    exit 1
fi

# Check if a screen session with the name 'minecraft' is already running
if screen -list | grep -q "minecraft"; then
    echo "Minecraft server is already running in a screen session."
    exit 1
fi

# Start a new screen session and run the Minecraft server inside it
screen -S minecraft -dm sudo -u minecraft java -Xms2G -Xmx4G -jar server.jar nogui

echo "Minecraft server started in a screen session."
