# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# VelocityScoreboardAPI plugin jar built from source, for mounting as an image volume.

FROM scratch AS src
ARG VERSION
ARG VERSION_COMMIT
# fails unless the tag still points at the pinned commit; keeps .git because
# the build derives its version suffix from git tags
ADD --keep-git-dir=true --checksum=${VERSION_COMMIT} https://github.com/NEZNAMY/VelocityScoreboardAPI.git#${VERSION} /

FROM --platform=$BUILDPLATFORM docker.io/library/eclipse-temurin:25.0.5_8-jdk-noble@sha256:80f67fb3d6f76e2d817d98a4cc2a9cf05f054d4e6adc5e2144bde671d722e63f AS plugin
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
ARG VERSION
COPY --from=src / /src
WORKDIR /src
RUN ./gradlew --no-daemon --console=plain :plugin:shadowJar \
    && mkdir /out \
    && cp "target/VelocityScoreboardAPI-${VERSION}.jar" /out/velocity-scoreboard-api.jar

FROM scratch
COPY --from=plugin --chmod=0644 /out/velocity-scoreboard-api.jar /velocity-scoreboard-api.jar
COPY --from=src --chmod=0644 /LICENSE /LICENSE
