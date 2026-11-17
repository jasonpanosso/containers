# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# hass-oidc-auth Home Assistant integration built from source, for mounting as an image volume.

FROM scratch AS src
ARG VERSION
ARG VERSION_COMMIT
# fails unless the tag still points at the pinned commit
ADD --checksum=${VERSION_COMMIT} https://github.com/christiaangoossens/hass-oidc-auth.git#${VERSION} /

# upstream's scripts/build: generate static/style.css with Tailwind, then ship custom_components/auth_oidc
FROM --platform=$BUILDPLATFORM docker.io/library/node:26.13.1-alpine3.24@sha256:6bd9ab43c0ec0190ca7b2d193906cb8b7edf6e7f4afa43ddeccd6452710bffb5 AS integration
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
COPY --from=src / /src
WORKDIR /src
RUN npm ci --no-audit --no-fund \
    && npm run css \
    && mkdir /out \
    && cp -r custom_components/auth_oidc/. /out/ \
    && cp LICENSE.md /out/LICENSE \
    && find /out -type d -exec chmod 0755 {} + \
    && find /out -type f -exec chmod 0644 {} +

FROM scratch
COPY --from=integration /out/ /
