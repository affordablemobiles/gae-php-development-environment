#!/bin/sh

PHPBUILDER=$(tail -n 1 /workspace/phpbuilder)

pack build --builder eu.gcr.io/gae-runtimes/buildpacks/php74/builder:$PHPBUILDER --publish eu.gcr.io/$PROJECT_ID/gcr-dev-intermediate:$COMMIT_SHA --env=GOOGLE_ENTRYPOINT=/workspace/entrypoint.sh --env=GOOGLE_RUNTIME=php74