#!/usr/bin/env bash
set -e
set -x

# Move to repo root
cd "$(dirname "$0")/.."  # scripts/.. -> repo root

DEPLOYMENT_NAME="$1"
IMAGE_NAME="$2"
TAG="$3"

CONTAINER_REGISTRY="azamazurecicd.azurecr.io"
YAML_FILE="k8s-specifications/${DEPLOYMENT_NAME}-deployment.yaml"

if [ ! -f "$YAML_FILE" ]; then
    echo "Error: Deployment YAML file not found: $YAML_FILE"
    exit 1
fi

NEW_IMAGE="image: ${CONTAINER_REGISTRY}/${IMAGE_NAME}:${TAG}"
sed -i "s|image:.*|$NEW_IMAGE|g" "$YAML_FILE"

git add "$YAML_FILE"

if git diff-index --quiet HEAD --; then
    echo "No changes to commit"
else
    git -c user.name='Azure DevOps' -c user.email='build@azuredevops.com' commit -m "Update Kubernetes manifest to tag ${TAG}"
    git push https://$SYSTEM_ACCESSTOKEN@dev.azure.com/mohdazam23/voting-app/_git/voting-app HEAD:$BUILD_SOURCEBRANCHNAME
fi
