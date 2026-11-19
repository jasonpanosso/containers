# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# Ambassador Velocity plugin jar built from source
FROM scratch AS src
ARG VERSION
ARG VERSION_COMMIT
# fails unless the tag still points at the pinned commit; keeps .git (and the
# Velocity submodule) because Velocity's build runs `git rev-parse HEAD`
ADD --keep-git-dir=true --checksum=${VERSION_COMMIT} https://github.com/adde0109/Ambassador.git#${VERSION} /

FROM --platform=$BUILDPLATFORM docker.io/library/eclipse-temurin:17.0.21_9-jdk-noble@sha256:f7f22e46d0f60856d74d602d6b61db29ece3d011e85183a718bea8341734cd52 AS plugin
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
RUN apt-get update -qq \
    && apt-get install -qqy --no-install-recommends git >/dev/null \
    && rm -rf /var/lib/apt/lists/*
COPY --from=src / /src
# Gradle 8 stamps jar entries with build-time mtimes; Gradle 9 defaults to this
COPY <<'EOF' /reproducible.gradle
allprojects {
    tasks.withType(AbstractArchiveTask).configureEach {
        preserveFileTimestamps = false
        reproducibleFileOrder = true
    }
}
EOF
WORKDIR /src
# gradlew isn't committed as executable
RUN sh ./gradlew --no-daemon --console=plain --init-script /reproducible.gradle shadowJar \
    && mkdir /out \
    && cp build/libs/Ambassador-Velocity-*-all.jar /out/ambassador.jar

FROM scratch
ARG VERSION
ARG VERSION_COMMIT
COPY --from=plugin --chmod=0644 /out/ambassador.jar /ambassador.jar
COPY --from=src --chmod=0644 /LICENSE /LICENSE
# LGPL-2.1: where the corresponding source for this build lives
COPY --chmod=0644 <<EOF /SOURCE
Ambassador ${VERSION}, built unmodified from:
https://github.com/adde0109/Ambassador/tree/${VERSION_COMMIT}
EOF
