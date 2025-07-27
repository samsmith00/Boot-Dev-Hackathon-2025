#!/bin/sh

# Download the latest AppImage from your GitHub releases or wherever you host it
curl -LO https://github.com/samsmith00/Boot-Dev-Hackathon-2025/releases/latest/download/Boot_Dev_Hackathon_Game-x86_64.AppImage

# Make it executable
chmod +x Boot_Dev_Hackathon_Game-x86_64.AppImage

# Run the game
./Boot_Dev_Hackathon_Game-x86_64.AppImage

