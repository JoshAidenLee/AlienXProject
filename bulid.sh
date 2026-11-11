#!/bin/bash
echo "🔨 Building Alien X Mobile IPA..."

xcodebuild clean -project AlienX.xcodeproj -scheme AlienX 2>/dev/null

xcodebuild build \
    -project AlienX.xcodeproj \
    -scheme AlienX \
    -configuration Release \
    -sdk iphoneos \
    ARCHS="arm64" \
    CODE_SIGNING_ALLOWED=NO \
    -derivedDataPath build

mkdir -p Payload
cp -r build/Build/Products/Release-iphoneos/AlienX.app Payload/
zip -r AlienX_Mobile_v1.0.ipa Payload/
rm -rf Payload

echo "✅ IPA created: AlienX_Mobile_v1.0.ipa"