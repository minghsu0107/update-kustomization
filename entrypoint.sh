#!/bin/sh
apk update && apk add --no-cache git && apk add --no-cache openssh
mkdir -p ~/.ssh && echo $SSH_KEY | base64 -d > ~/.ssh/id_rsa && chmod 700 ~/.ssh/id_rsa && ssh-keyscan $MANIFEST_HOST >> ~/.ssh/known_hosts
rm -rf $MANIFEST_REPO && git clone ssh://git@$MANIFEST_HOST/$MANIFEST_USER/$MANIFEST_REPO.git

git checkout $MANIFEST_BRANCH
cd $MANIFEST_REPO/$KUSTOMIZATION

for IMAGE in $(echo $IMAGES | sed "s/,/ /g")
do
    kustomize edit set image $IMAGE:$IMAGE_TAG
done

git add . && git commit --allow-empty -m "🚀 update to ${IMAGE_TAG}"
git push ssh://git@$MANIFEST_HOST/$MANIFEST_USER/$MANIFEST_REPO.git
