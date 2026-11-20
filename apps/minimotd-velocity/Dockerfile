# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# MiniMOTD Velocity plugin jar built from source
FROM scratch AS src
ARG VERSION
ARG VERSION_COMMIT
# fails unless the tag still points at the pinned commit
ADD --checksum=${VERSION_COMMIT} https://github.com/jpenilla/MiniMOTD.git#${VERSION} /

FROM --platform=$BUILDPLATFORM docker.io/library/eclipse-temurin:25.0.5_8-jdk-noble@sha256:3c35c595580ae3342eb34e5832e8e516ded8e767efa4a5fe61b8644d44847b8e AS plugin
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
COPY --from=src / /src
WORKDIR /src
RUN ./gradlew --no-daemon --console=plain :minimotd-velocity:shadowJar \
    && mkdir /out \
    && cp platform/velocity/build/libs/minimotd-velocity-*.jar /out/minimotd.jar

FROM scratch
COPY --from=plugin --chmod=0644 /out/minimotd.jar /minimotd.jar
COPY --from=src --chmod=0644 /license.txt /LICENSE
