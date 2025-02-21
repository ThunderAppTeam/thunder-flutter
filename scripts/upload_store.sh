#!/bin/bash

update_version() {
    read -p "Do you want to update version? (y/N): " should_update
    if [[ "$should_update" =~ ^[Yy]$ ]]; then
        ./scripts/version.sh
    fi 
}

read -p "Upload to Store (android/ios): " platform

case $platform in
    "android")
        update_version
        ( cd android && fastlane deploy )
        ;;
    "ios")
        update_version
        ( cd ios && fastlane beta )
        ;;
    *)
        echo "Invalid platform. Use 'android' or 'ios'"
        exit 1
        ;;
esac