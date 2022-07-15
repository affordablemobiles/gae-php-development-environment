#!/bin/sh

add-apt-repository ppa:cncf-buildpacks/pack-cli
apt-get update
apt-get install pack-cli

PHPBUILDER=$(tail -n 1 /workspace/phpbuilder)

pack build eu.gcr.io/$PROJECT_ID/gcr-dev-intermediate:$COMMIT_SHA --builder eu.gcr.io/gae-runtimes/buildpacks/php81/builder:$PHPBUILDER --env=GOOGLE_ENTRYPOINT=/workspace/entrypoint.sh --env=GOOGLE_RUNTIME=php81 --env=X_GOOGLE_TARGET_PLATFORM=gae