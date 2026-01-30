#!/bin/bash
set -e

# Build script for Amazon Linux 2023 aarch64 Docker image
# Usage: ./build.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="rolesanywhere-credential-helper-al2023-aarch64-builder"
IMAGE_TAG="latest"

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Get Go version from go.mod
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
GO_VERSION=$(grep '^toolchain' "${WORKSPACE_ROOT}/go.mod" | awk '{print $2}' | sed 's/go//')

echo "Using Go version: ${GO_VERSION}"

# Build for aarch64 from the docker image directory
docker buildx build \
    --platform linux/arm64 \
    --build-arg GO_VERSION="${GO_VERSION}" \
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    -f "${SCRIPT_DIR}/Dockerfile" \
    --load \
    "${SCRIPT_DIR}"

echo "Build complete."