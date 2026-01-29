#!/bin/bash
set -e

# Build script for Amazon Linux 2023 x86_64 Docker image
# Usage: ./build.sh [--push]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="rolesanywhere-credential-helper-al2023-x86_64-builder"
IMAGE_TAG="latest"

# Parse arguments
PUSH=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --push)
            PUSH=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--push]"
            exit 1
            ;;
    esac
done

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Build for x86_64
docker buildx build \
    --platform linux/amd64 \
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    ${PUSH:+--push} \
    "${SCRIPT_DIR}"

echo "Build complete!"
if [ "$PUSH" = true ]; then
    echo "Image pushed to registry"
else
    echo "Image built locally (use --push to push to registry)"
fi
