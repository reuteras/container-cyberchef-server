# Build container
FROM node:14-alpine AS build-env
LABEL maintainer="Coding <code@ongoing.today>"

USER root
WORKDIR /

RUN apk update && \
    apk add --no-cache \
        git && \
    git clone -b 'master' --single-branch --no-tags --depth=1 https://github.com/gchq/CyberChef-server.git

# Container
# This if from https://github.com/gchq/CyberChef-server/blob/master/Dockerfile
# The COPY statement has been changed to use build-env as source.
FROM node:14-alpine
LABEL author "Wes Lambert, wlambertts@gmail.com"
LABEL description="Dockerised version of Cyberchef server (https://github.com/gchq/CyberChef-server)"
LABEL copyright "Crown Copyright 2020"
LABEL license "Apache-2.0"
COPY --from=build-env /CyberChef-server /CyberChef-server
RUN npm cache clean --force && \
    npm install /CyberChef-server
ENTRYPOINT ["npm", "--prefix", "/CyberChef-server", "run", "prod"]
