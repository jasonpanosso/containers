# syntax=docker/dockerfile:1

# Simple Voice Chat Velocity plugin jar only, for mounting as an image volume.

FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.4@sha256:93b41ef40b1677fce8fcc64ff4af09daddfacf5040afde618bc46c1e2d1cc7d4 AS plugin
ARG VERSION
WORKDIR /out
RUN \
    file="$(wget -qO- \
        -U "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        'https://api.modrinth.com/v2/project/simple-voice-chat/version?loaders=%5B%22velocity%22%5D' \
        | jq -e --arg version "${VERSION}" '.[] | select(.version_number == $version) | .files[] | select(.primary)')" \
    && wget -qO simple-voice-chat.jar "$(echo "$file" | jq -r '.url')" \
    && echo "$(echo "$file" | jq -r '.hashes.sha512')  simple-voice-chat.jar" | sha512sum -c

FROM scratch
COPY --from=plugin --chmod=0644 /out/simple-voice-chat.jar /simple-voice-chat.jar
