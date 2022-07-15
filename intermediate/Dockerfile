ARG IMAGE=eu.gcr.io/demo/container
ARG TAG=tag
FROM ${IMAGE}:${TAG}

USER root

RUN apt-get update && apt-get install -y nfs-common sudo && apt-get clean

RUN echo "www-data ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER www-data
