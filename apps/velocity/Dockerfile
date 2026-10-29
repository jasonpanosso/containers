# syntax=docker/dockerfile:1

# Velocity jar only, for mounting as an image volume; Java comes from the
# consuming pod.

FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS velocity
ARG VERSION
RUN apk add --no-cache curl jq
WORKDIR /out
RUN \
    build="$(curl -fsSL \
        -A "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        "https://fill.papermc.io/v3/projects/velocity/versions/${VERSION#*v}/builds/latest")" \
    && echo "$build" | jq -e '.channel == "STABLE"' \
    && curl -fsSL -o velocity.jar "$(echo "$build" | jq -r '.downloads."server:default".url')" \
    && echo "$(echo "$build" | jq -r '.downloads."server:default".checksums.sha256')  velocity.jar" | sha256sum -c

FROM scratch
COPY --from=velocity --chmod=0644 /out/velocity.jar /velocity.jar
