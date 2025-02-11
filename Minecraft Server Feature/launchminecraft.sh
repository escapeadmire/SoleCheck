#!/bin/bash
# Start Minecraft Server in a screen session
screen -S minecraft -L -Logfile /home/kurt/Minecraft.log bash -c "sudo -u minecraft bash -c 'cd /home/minecraft/Minecraft && java -Xms2G -Xmx4G -jar server.jar nogui'"

echo "Minecraft server started in a screen session."
