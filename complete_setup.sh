#!/bin/bash
echo "🚀 Complete Alien X Mobile Setup"

mkdir -p AlienXProject
cd AlienXProject

chmod +x build.sh
./build.sh

echo "📤 Uploading to InstallOnAir..."
pip3 install requests
python3 upload_to_installonair.py

echo "🔄 Alternative: Uploading to Diawi..."
python3 upload_to_diawi.py
