# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS integration
ARG VERSION
RUN apk add --no-cache curl jq
WORKDIR /out
RUN \
    asset="$(curl -fsSL \
        -A "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        "https://api.github.com/repos/christiaangoossens/hass-oidc-auth/releases/tags/${VERSION}" \
        | jq -e '.assets[] | select(.name == "hass-oidc-auth.zip")')" \
    && curl -fsSL -o /tmp/auth_oidc.zip "$(echo "$asset" | jq -r '.browser_download_url')" \
    && echo "$(echo "$asset" | jq -r '.digest | ltrimstr("sha256:")')  /tmp/auth_oidc.zip" | sha256sum -c \
    && unzip -q /tmp/auth_oidc.zip -d /out \
    && find /out -type d -exec chmod 0755 {} + \
    && find /out -type f -exec chmod 0644 {} +

FROM scratch
COPY --from=integration /out/ /
