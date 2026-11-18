# syntax=docker/dockerfile:1.29.0@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183

# ajQueue plugin jar built from source
FROM scratch AS src
ARG VERSION
ARG VERSION_COMMIT
# fails unless the tag still points at the pinned commit
ADD --checksum=${VERSION_COMMIT} https://github.com/ajgeiss0702/ajQueue.git#${VERSION} /

FROM --platform=$BUILDPLATFORM docker.io/library/eclipse-temurin:25.0.5_8-jdk-noble@sha256:80f67fb3d6f76e2d817d98a4cc2a9cf05f054d4e6adc5e2144bde671d722e63f AS plugin
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
ARG VERSION
COPY --from=src / /src
WORKDIR /src
# fix 2.9.1 pointing at the retired nexus.velocitypowered.com
RUN grep -q 'nexus.velocitypowered.com/repository/maven-public/' platforms/bungeecord/build.gradle.kts \
    && sed -i 's#https://nexus\.velocitypowered\.com/repository/maven-public/#https://repo.papermc.io/repository/maven-public/#' \
        platforms/bungeecord/build.gradle.kts \
    && ./gradlew --no-daemon --console=plain :free:shadowJar \
    && mkdir /out \
    && cp "free/build/libs/ajQueue-${VERSION}.jar" /out/ajqueue.jar

FROM scratch
COPY --from=plugin --chmod=0644 /out/ajqueue.jar /ajqueue.jar
COPY --from=src --chmod=0644 /LICENSE /LICENSE
