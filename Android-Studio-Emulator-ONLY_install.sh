#!/bin/bash
# chmod +x Android-Studio-Emulator-ONLY_install.sh

brew install temurin

echo "📦 Creating Android SDK folder..."
mkdir -p ~/Library/Android/sdk/cmdline-tools

echo "⬇️ Downloading command line tools..."
cd ~/Downloads
curl -O https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip

echo "📂 Extracting..."
unzip commandlinetools-mac-11076708_latest.zip -d ~/Library/Android/sdk/cmdline-tools
mv ~/Library/Android/sdk/cmdline-tools/cmdline-tools ~/Library/Android/sdk/cmdline-tools/latest

echo "🛠️ Setting up environment variables..."
echo '
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$PATH
' >> ~/.zprofile
source ~/.zprofile

echo "📥 Installing SDK components..."
sdkmanager --install "platform-tools" "emulator" "system-images;android-36;google_apis_playstore_ps16k;arm64-v8a"
sdkmanager --update

echo "📱 Creating emulator..."
echo "no" | avdmanager create avd -n testAVD -k "system-images;android-36;google_apis_playstore_ps16k;arm64-v8a" --device "pixel" --force

# Modify AVD config to enable keyboard and GPU
AVD_CONFIG="$HOME/.android/avd/testAVD.avd/config.ini"
if [ -f "$AVD_CONFIG" ]; then
  grep -q "hw.keyboard=yes" "$AVD_CONFIG" || echo "hw.keyboard=yes" >> "$AVD_CONFIG"
  grep -q "hw.gpu=yes" "$AVD_CONFIG" || echo "hw.gpu=yes" >> "$AVD_CONFIG"
fi
echo "hw.gpu.mode=swiftshader_indirect" >> ~/.android/avd/testAVD.avd/config.ini

echo "✅ Done! Launching emulator..."
emulator -avd testAVD &



# Delete system image folders you don't need to save space:
# cd ~/Library/Android/sdk/system-images/

