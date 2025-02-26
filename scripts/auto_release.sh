#!/bin/bash

# 1. Update version first
./scripts/version.sh

# 2. Distribute to Firebase (both platforms)
echo "Distributing to Firebase..."
(echo "android"; echo "n") | ./scripts/distribute.sh
(echo "ios"; echo "n") | ./scripts/distribute.sh

# 3. Upload to stores
echo "Uploading to stores..."
(echo "android"; echo "n") | ./scripts/upload_store.sh
(echo "ios"; echo "n") | ./scripts/upload_store.sh