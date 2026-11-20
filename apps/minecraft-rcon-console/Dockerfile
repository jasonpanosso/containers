# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183
# check=error=true

# Rauks/Minecraft-RCON-Console built from source with paid fonts swapped out
FROM scratch AS src
ARG VERSION
ARG VERSION_COMMIT
ADD --checksum=${VERSION_COMMIT} https://github.com/Rauks/Minecraft-RCON-Console.git#${VERSION} /

FROM --platform=$BUILDPLATFORM docker.io/library/node:26.13.1-alpine3.24@sha256:6bd9ab43c0ec0190ca7b2d193906cb8b7edf6e7f4afa43ddeccd6452710bffb5 AS ui
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ARG VERSION
COPY --from=src /ui /ui
WORKDIR /ui
COPY fontawesome-pro-shim /fontawesome-pro-shim
RUN <<'EOF'
set -eu

# swap paid icon package with standin (./fontawesome-pro-shim)
rm -f .npmrc
sed -i 's|https://npm.fontawesome.com/|https://registry.npmjs.org/|' package-lock.json
fa="$(node -p 'require("./package-lock.json").packages["node_modules/@fortawesome/fontawesome-svg-core"].version')"
npm uninstall --no-audit --no-fund @fortawesome/pro-solid-svg-icons @fortawesome/pro-regular-svg-icons
npm install --install-links --no-audit --no-fund /fontawesome-pro-shim \
    "@fortawesome/free-solid-svg-icons@${fa}" \
    "@fortawesome/pro-regular-svg-icons@npm:@fortawesome/free-regular-svg-icons@${fa}"
sed -i "s|%VERSION_SLUG%|${VERSION}|" src/environments/environment.prod.ts

# fail if upstream uses a pro icon the stand-in doesn't cover
node -e '
const fs = require("fs"), path = require("path");
const { fas } = require("@fortawesome/pro-solid-svg-icons");
const have = new Set(Object.values(fas).flatMap(d => [d.iconName, ...d.icon[2].filter(a => typeof a === "string")]));
const walk = d => fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]);
const used = new Set(walk("src").filter(f => f.endsWith(".html")).flatMap(f => [...fs.readFileSync(f, "utf8").matchAll(/\sicon="([^"]+)"/g)].map(m => m[1])));
JSON.parse(fs.readFileSync("src/config/shortcuts.json", "utf8")).forEach(s => used.add(s.icon));
const missing = [...used].filter(n => !have.has(n));
if (missing.length) { console.error("Icons missing from the stand-in:", missing.join(", ")); process.exit(1); }
'
npx ng build --configuration production
EOF

FROM docker.io/library/rust:1.100.0-alpine3.24@sha256:8d0e82abfdf9a38071e07cabc5afba4ddbe077631a80e4e742a760c38beadc33 AS api
COPY --from=src / /src
WORKDIR /src
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    cargo build --release --locked \
    && cp target/release/minecraft-rcon /minecraft-rcon

FROM gcr.io/distroless/static-debian13:nonroot@sha256:aafe993665bf6200db38a02c11a9351e782a84b6a45e7f33b6695638c88e3931
COPY --from=api --chmod=0755 /minecraft-rcon /usr/local/bin/minecraft-rcon
COPY --from=ui /ui/dist/browser /usr/share/minecraft-rcon/www
COPY --from=src /LICENSE /usr/share/doc/minecraft-rcon/LICENSE
# the stand-in icon package from this repo is bundled into the UI
COPY --chmod=0644 fontawesome-pro-shim/LICENSE /usr/share/doc/minecraft-rcon/fontawesome-pro-shim-LICENSE
# licenses of the npm packages bundled into the UI, written by the production ng build
COPY --from=ui /ui/dist/3rdpartylicenses.txt /usr/share/doc/minecraft-rcon/ui-3rdpartylicenses.txt

# no RCON_HOST/RCON_PASSWORD defaults: the server starts, but rcon requests fail until they are set
ENV RCON_PORT=25575 \
    ROOT_WWW=/usr/share/minecraft-rcon/www \
    ROCKET_ADDRESS=0.0.0.0 \
    ROCKET_PORT=8888 \
    ROCKET_LIMITS={json="1 MiB"} \
    ROCKET_IP_HEADER=X-Forwarded-For \
    ROCKET_CLI_COLORS=false \
    RUST_LOG=warn,minecraft_rcon=info \
    RUST_TRACES=info
EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/minecraft-rcon"]
