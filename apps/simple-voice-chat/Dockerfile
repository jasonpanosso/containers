# syntax=docker/dockerfile:1

# Simple Voice Chat Velocity plugin jar only, for mounting as an image volume.

FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS plugin
ARG VERSION
RUN apk add --no-cache curl jq
WORKDIR /out
RUN \
    file="$(curl -fsSL \
        -A "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        'https://api.modrinth.com/v2/project/simple-voice-chat/version?loaders=%5B%22velocity%22%5D' \
        | jq -e --arg version "${VERSION}" '.[] | select(.version_number == $version) | .files[] | select(.primary)')" \
    && curl -fsSL -o simple-voice-chat.jar "$(echo "$file" | jq -r '.url')" \
    && echo "$(echo "$file" | jq -r '.hashes.sha512')  simple-voice-chat.jar" | sha512sum -c

FROM scratch
COPY --from=plugin --chmod=0644 /out/simple-voice-chat.jar /simple-voice-chat.jar
