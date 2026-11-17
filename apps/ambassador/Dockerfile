# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# Ambassador Velocity plugin jar only, for mounting as an image volume.

FROM --platform=$BUILDPLATFORM ghcr.io/jqlang/jq:1.8.2@sha256:b9c68867e5766576263a222e91db3de422d802069c7af70440e667a95344e486 AS jq
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS plugin
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
COPY --from=jq /jq /usr/local/bin/jq
ARG VERSION
WORKDIR /out
RUN \
    asset="$(wget -qO- \
        -U "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        "https://api.github.com/repos/adde0109/Ambassador/releases/tags/${VERSION}" \
        | jq -e '[.assets[] | select(.name | test("^Ambassador-Velocity-.*-all\\.jar$"))] \
            | if length == 1 then .[0] else error("expected one Velocity jar, found \(length)") end')" \
    && wget -qO ambassador.jar "$(echo "$asset" | jq -r '.browser_download_url')" \
    && digest="$(echo "$asset" | jq -r '.digest // "" | ltrimstr("sha256:")')" \
    && if [ -n "$digest" ]; then echo "$digest  ambassador.jar" | sha256sum -c; fi

FROM scratch
COPY --from=plugin --chmod=0644 /out/ambassador.jar /ambassador.jar
