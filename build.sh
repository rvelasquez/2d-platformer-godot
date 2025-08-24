#!/bin/bash
set -e

# Define color variables.
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for colored output.
info() {
  echo -e "${BLUE}[INFO] $1${NC}"
}

success() {
  echo -e "${GREEN}[SUCCESS] $1${NC}"
}

warn() {
  echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
  echo -e "${RED}[ERROR] $1${NC}"
}

# Print the script's content before running any commands.
info "===== build.sh content start ====="
cat "$0"
info "===== build.sh content end ====="

info "Running Godot import"
godot --headless -e --quit-after 100

info "Zipping project"
eval "$ZIPCOMMAND"

info "Initiating upload process..."

# Step 1: Post an empty body to get the upload URL.
response=$(curl -s -X POST "${uploadUrl}?godot_id=${GODOT_ASSET_ID}&xogot_id=${XOGOT_ASSET_ID}&version=${version}&tags=${TAGS}&iconUrl=${ICON_URL}${EXTRA_ARGS}" \
  -H "apiKey: ${apiKey}" -d "")

if [ -z "$response" ]; then
    error "Empty response from upload initiation"
    exit 1
fi

# Parse the JSON response for the uploadUrl property.
upload_url=$(echo "$response" | jq -r '.uploadUrl')
if [ -z "$upload_url" ] || [ "$upload_url" == "null" ]; then
    error "Failed to retrieve uploadUrl from response: $response"
    exit 1
fi

info "Upload URL retrieved: $upload_url"

# Step 2: PUT the zip file to the retrieved upload URL.
upload_response=$(curl -f -X PUT --data-binary "@build.zip" "$upload_url" -H "Content-Type: application/octet-stream" 2>&1) || {
    error "Zip upload failed with output:"
    echo "$upload_response"
    exit 1
}

success "Zip upload successful"
info "Upload response: $upload_response"