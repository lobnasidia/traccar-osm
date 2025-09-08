# Étape 1 : Récupérer Traccar depuis une archive
FROM alpine AS package
ARG VERSION=5.12
RUN apk add --no-cache unzip curl
RUN curl -L -o /tmp/traccar.zip https://github.com/traccar/traccar/releases/download/v${VERSION}/traccar-other-${VERSION}.zip
RUN unzip -qo /tmp/traccar.zip -d /traccar

# Étape 2 : Construire un JRE minimal avec jlink
FROM eclipse-temurin:21-jammy AS jdk
RUN jlink --module-path $JAVA_HOME/jmods \
    --add-modules java.se,jdk.charsets,jdk.crypto.ec,jdk.unsupported \
    --strip-debug --no-header-files --no-man-pages --compress=2 --output /jre

# Étape 3 : Image finale
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y tzdata && rm -rf /var/lib/apt/lists/*
COPY --from=package /traccar /opt/traccar
COPY --from=jdk /jre /opt/traccar/jre
WORKDIR /opt/traccar
EXPOSE 8082
ENTRYPOINT ["/opt/traccar/jre/bin/java"]
CMD ["-jar", "tracker-server.jar", "conf/traccar.xml"]
