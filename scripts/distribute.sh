#!/bin/bash

update_version() {
    read -p "Do you want to  version? (y/N): " should_update
    if [[ "$should_update" =~ ^[Yy]$ ]]; then
        ./scripts/version.sh
    fi 
}

read -p "Deploy to (android/ios): " platform

case $platform in
    "android")
        update_version
        ( cd android && fastlane distribute )
        ;;
    "ios")
        update_version
        ( cd ios && fastlane distribute )
        ;;
    *)
        echo "Invalid platform. Use 'android' or 'ios'"
        exit 1
        ;;
esac