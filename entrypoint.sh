#!/bin/sh
apk update && apk add --no-cache git && apk add --no-cache openssh
mkdir -p ~/.ssh && echo $SSH_KEY | base64 -d > ~/.ssh/id_rsa && chmod 700 ~/.ssh/id_rsa && ssh-keyscan $MANIFEST_HOST >> ~/.ssh/known_hosts
rm -rf $MANIFEST_REPO && git clone ssh://git@$MANIFEST_HOST/$MANIFEST_USER/$MANIFEST_REPO.git
cd $MANIFEST_REPO/$SVC_PATH && kustomize edit set image $CONTAINER_REPO:${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}
git add . && git commit -m "🚀 update to ${DRONE_COMMIT_BRANCH}-${DRONE_COMMIT_SHA:0:7}"
git push ssh://git@$MANIFEST_HOST/$MANIFEST_USER/$MANIFEST_REPO.git