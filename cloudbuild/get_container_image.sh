#!/bin/bash

gcloud container images list-tags eu.gcr.io/gae-runtimes/buildpacks/php81/builder | awk -F'_' '{print $2+0}'>tagfilter.txt

TAGDATE=0

while read tag; do
  if [[ $tag -gt $TAGDATE ]]; then
    TAGDATE=$tag
  fi
done<tagfilter.txt

echo "Latest date found for builder: $TAGDATE"

PHPBUILDER_TMP=$(gcloud container images list-tags eu.gcr.io/gae-runtimes/buildpacks/php81/builder --filter php81_$TAGDATE | awk 'NR==2 {print $2}')
PHPBUILDER=${PHPBUILDER_TMP##*,}

echo "Being built with builder image tag $PHPBUILDER"

rm tagfilter.txt

echo -n $PHPBUILDER>/workspace/phpbuilder
