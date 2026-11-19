# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# Velocity jar only
FROM --platform=$BUILDPLATFORM ghcr.io/jqlang/jq:1.8.2@sha256:b9c68867e5766576263a222e91db3de422d802069c7af70440e667a95344e486 AS jq
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS velocity
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
COPY --from=jq /jq /usr/local/bin/jq
ARG VERSION
ARG VERSION_COMMIT
WORKDIR /out
# newest stable PaperMC build of the VERSION_COMMIT tag commit
RUN \
    build="$(wget -qO- \
        -U "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        "https://fill.papermc.io/v3/projects/velocity/versions/${VERSION#*v}/builds" \
        | jq -ec --arg commit "${VERSION_COMMIT}" \
            'map(select(.channel == "STABLE" and .commits[0].sha == $commit)) | max_by(.id)')" \
    && wget -qO velocity.jar "$(echo "$build" | jq -r '.downloads."server:default".url')" \
    && echo "$(echo "$build" | jq -r '.downloads."server:default".checksums.sha256')  velocity.jar" | sha256sum -c \
    && wget -qO LICENSE "https://raw.githubusercontent.com/PaperMC/Velocity/${VERSION_COMMIT}/LICENSE" \
    && printf 'Velocity %s (PaperMC build %s), unmodified, built from:\nhttps://github.com/PaperMC/Velocity/tree/%s\n' \
        "${VERSION#v}" "$(echo "$build" | jq -r '.id')" "${VERSION_COMMIT}" > SOURCE

FROM scratch
COPY --from=velocity --chmod=0644 /out/velocity.jar /out/LICENSE /out/SOURCE /
