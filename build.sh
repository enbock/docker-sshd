IMAGE_NAME="$1"
INSTANCE="$(docker buildx create --use)"
echo "Buildx: $INSTANCE"
docker buildx build --platform linux/amd64 --push -t $IMAGE_NAME .
docker buildx rm "$INSTANCE"
