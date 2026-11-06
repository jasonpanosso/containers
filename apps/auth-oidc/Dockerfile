# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM ghcr.io/jqlang/jq:1.8.2@sha256:b9c68867e5766576263a222e91db3de422d802069c7af70440e667a95344e486 AS jq
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.24.4@sha256:93b41ef40b1677fce8fcc64ff4af09daddfacf5040afde618bc46c1e2d1cc7d4 AS integration
COPY --from=jq /jq /usr/local/bin/jq
ARG VERSION
WORKDIR /out
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN \
    asset="$(wget -qO- \
        -U "jasonpanosso/containers (https://github.com/jasonpanosso/containers)" \
        ${GITHUB_TOKEN:+--header "Authorization: Bearer ${GITHUB_TOKEN}"} \
        "https://api.github.com/repos/christiaangoossens/hass-oidc-auth/releases/tags/${VERSION}" \
        | jq -e '.assets[] | select(.name == "hass-oidc-auth.zip")')" \
    && wget -qO /tmp/auth_oidc.zip "$(echo "$asset" | jq -r '.browser_download_url')" \
    && echo "$(echo "$asset" | jq -r '.digest | ltrimstr("sha256:")')  /tmp/auth_oidc.zip" | sha256sum -c \
    && unzip -q /tmp/auth_oidc.zip -d /out \
    && find /out -type d -exec chmod 0755 {} + \
    && find /out -type f -exec chmod 0644 {} +

FROM scratch
COPY --from=integration /out/ /
