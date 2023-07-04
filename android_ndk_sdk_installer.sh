#!/bin/bash


# Installing Android SDK

cd /opt
echo "Downloading Android SDK..."
wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
unzip sdk-tools-linux-3859397.zip -d android-sdk
rm sdk-tools-linux-3859397.zip

echo "Updating Android SDK..."
cd android-sdk/tools/bin
echo y | ./sdkmanager --update

cd /opt/android-sdk/tools/bin
mkdir -p ~/.android
touch ~/.android/repositories.cfg


echo "Installing platform tools from 20 to latest"
./sdkmanager "platform-tools" 
for platform in $(./sdkmanager --list | grep platforms | cut -d'|' -f1); do 
	if [ "$(echo $platform | cut -d'-' -f2)" -ge "20" ]; then 
		./sdkmanager "$platform"
	fi
done

echo "Installing build tools"
for build in $(./sdkmanager --list | grep build-tools | cut -d'|' -f1); do
	./sdkmanager "$build"
done

echo "Installing extra repositories"
for repository in $(./sdkmanager --list | grep extras | cut -d'|' -f1); do
	./sdkmanager "$repository"
done



# Installing Android NDK

cd /opt
echo "Downloading Android NDK..."
wget https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip
unzip android-ndk-r14b-linux-x86_64.zip
rm android-ndk-r14b-linux-x86_64.zip

mv android-ndk-r14b android-ndk



# Fixing permissions and system variables

chmod -R 777 /opt/android-sdk /opt/android-ndk ~/.android 

echo "Creating system variables"
echo "export ANDROID_HOME=/opt/android-sdk" >> ~/.bashrc
echo "export ANDROID_NDK_HOME=/opt/android-ndk" >> ~/.bashrc
echo "export ANDROID_TOOLS=/opt/android-sdk/tools/bin" >> ~/.bashrc
echo "export ANDROID_PLATFORM_TOOLS=/opt/android-sdk/platform-tools" >> ~/.bashrc
echo "export PATH=$PATH:$ANDROID_HOME:$ANDROID_TOOLS:$ANDROID_PLATFORM_TOOLS:$ANDROID_NDK_HOME" >> ~/.bashrc

echo "New system variables: ANDROID_HOME, ANDROID_NDK_HOME, ANDROID_TOOLS, ANDROID_PLATFORM_TOOLS"

# Installing required library
apt-get install zlib1g -y
