#!/bin/bash

version=75

echo "Uninstalling previous version of PIA................"
rm -rf ~/.pia_manager/

echo "Removing the start or application menu icon............."
rm ~/.local/share/applications/pia_manager.desktop

echo "Changing to the Downloads directory..............."
cd ~/Downloads

echo "Downloading latest version of PIA......."
wget https://installers.privateinternetaccess.com/download/pia-v${version}-installer-linux.tar.gz
if [ $? -eq 0 ]; then
    echo "Download successful!"
else
    echo "Download failed! You may already have downloaded the latest version. Try to manually change the version variable to the latest version of PIA available"
    exit 1
fi

echo "Checking shasum........"

cmp -bl <(shasum -a 256 pia-v${version}-installer-linux.tar.gz | awk '{print $1}') <(curl https://www.privateinternetaccess.com/pages/downloads 2>/dev/null | sed -n "s/<p class='sha256'>pia-v${version}-installer-linux.tar.gz: \(.\+\)<\/p>/\1/p")
if [ $? -eq 0 ]; then
    echo shasum OK
else
    echo shasum FAILED
    exit 1
fi

next_version=$((version + 1))
echo "Increasing version number to: ${next_version} ............."
sed -i "s/${version}/${next_version}/g" ~/update_PIA.sh

echo "Uncompressing the installer............."
tar -xzf pia-v${version}-installer-linux.tar.gz

echo "Running the installer.................."
./pia-v${version}-installer-linux.sh
if [ $? -eq 0 ]; then
    echo "Installation SUCCESSFUL"
else
    echo "Installation FAILED"
    exit 1
fi

echo "Removing downloaded PIA package..............."
rm pia-v${version}-installer-linux.tar.gz

echo "Removing installation script................."
rm pia-v${version}-installer-linux.sh


