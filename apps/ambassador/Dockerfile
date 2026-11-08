# syntax=docker/dockerfile:1

# Ambassador Velocity plugin jar only, for mounting as an image volume.

FROM --platform=$BUILDPLATFORM ghcr.io/jqlang/jq:1.8.2@sha256:b9c68867e5766576263a222e91db3de422d802069c7af70440e667a95344e486 AS jq
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS plugin
COPY --from=jq /jq /usr/local/bin/jq
ARG VERSION
WORKDIR /out
RUN \
    file="$(wget -qO- \
        -U "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        'https://api.modrinth.com/v2/project/ambassador/version?loaders=%5B%22velocity%22%5D' \
        | jq -e --arg version "${VERSION}" '.[] | select(.version_number == $version) | .files[] | select(.primary)')" \
    && wget -qO ambassador.jar "$(echo "$file" | jq -r '.url')" \
    && echo "$(echo "$file" | jq -r '.hashes.sha512')  ambassador.jar" | sha512sum -c

FROM scratch
COPY --from=plugin --chmod=0644 /out/ambassador.jar /ambassador.jar
