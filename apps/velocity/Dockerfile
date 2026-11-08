# syntax=docker/dockerfile:1

# Velocity jar only, for mounting as an image volume; Java comes from the
# consuming pod.

FROM --platform=$BUILDPLATFORM ghcr.io/jqlang/jq:1.8.2@sha256:b9c68867e5766576263a222e91db3de422d802069c7af70440e667a95344e486 AS jq
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS velocity
COPY --from=jq /jq /usr/local/bin/jq
ARG VERSION
WORKDIR /out
RUN \
    build="$(wget -qO- \
        -U "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        "https://fill.papermc.io/v3/projects/velocity/versions/${VERSION#*v}/builds/latest")" \
    && echo "$build" | jq -e '.channel == "STABLE"' \
    && wget -qO velocity.jar "$(echo "$build" | jq -r '.downloads."server:default".url')" \
    && echo "$(echo "$build" | jq -r '.downloads."server:default".checksums.sha256')  velocity.jar" | sha256sum -c

FROM scratch
COPY --from=velocity --chmod=0644 /out/velocity.jar /velocity.jar
